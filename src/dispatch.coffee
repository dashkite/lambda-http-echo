import echo from "./echo"
import rune from "./rune"

dispatch = ( request ) ->
  url = new URL request.url
  if url.pathname == "/echo-rune"
    await rune request
  else
    await echo request

export default dispatch