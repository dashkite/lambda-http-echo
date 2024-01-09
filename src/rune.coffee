import * as Runes from "@dashkite/runes"
import { confidential } from "panda-confidential"
import { JSON64 } from "./helpers"

Confidential = confidential()


handler = ( request ) ->
  { authorization } = request.query
  if !authorization?
    return 
      description: "bad request"
      content: "did not include authorization query parameter"

  authorization = JSON64.decode authorization

  secret = Confidential.convert
    from: "bytes"
    to: "base64"
    await Confidential.randomBytes 16

  { rune, nonce } = await Runes.issue { authorization, secret }

  description: "ok"
  content: { rune, nonce }

export default handler