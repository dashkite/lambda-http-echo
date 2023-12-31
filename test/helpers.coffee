import { convert } from "@dashkite/bake"
import * as DRN from "@dashkite/drn-sky"

encode = ( url, object ) ->
  url.searchParams.set "echo",
    convert from: "utf8", to: "safe-base64", JSON.stringify object


request = ( method, path, sublime ) ->
  domain = await DRN.resolve "drn:domain/echo/dashkite/io"
  url = new URL path, "https://#{ domain }"
  encode url, sublime

  # console.log url.href
  await fetch url.href, { method }

export {
  request
} 
