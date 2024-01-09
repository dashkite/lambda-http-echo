import { convert } from "@dashkite/bake"
import * as DRN from "@dashkite/drn-sky"

encode = ( url, object ) ->
  url.searchParams.set "echo",
    convert from: "utf8", to: "base64", JSON.stringify object


request = ( method, path, headers, sublime ) ->
  domain = await DRN.resolve "drn:domain/echo/dashkite/io"
  url = new URL path, "https://#{ domain }"
  encode url, sublime

  # console.log url.href
  await fetch url.href, { method, headers }

rune = ( method, authorization ) ->
  domain = await DRN.resolve "drn:domain/echo/dashkite/io"
  url = new URL "/echo-rune", "https://#{ domain }"
  value = convert from: "utf8", to: "base64", JSON.stringify authorization
  url.searchParams.set "authorization", value

  # console.log url.href
  await fetch url.href, { method }

export {
  request
  rune
} 
