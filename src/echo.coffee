import * as Fn from "@dashkite/joy/function"
import * as Obj from "@dashkite/joy/object"
import { Machine, Sync, $end } from "@dashkite/talos"
import { convert } from "@dashkite/bake"

Match =
  echo: ( talos ) -> talos.context.request.query.echo?
  method: ( method ) ->
    ( talos, request ) -> request.method == method

Parse =
  echo: ( talos ) -> 
    { echo } = talos.context.request.query
    talos.context.echo = 
      JSON.parse convert from: "base64", to: "utf8", echo

  target: ( talos ) ->
    url = new URL talos.context.request.url
    url.searchParams.delete "echo"
    talos.context.$echo = 
      path: url.pathname
      query: url.search


Response =
  default: ( talos ) ->
    talos.context.response =
      description: "bad request"
      content:
        from: "echo"
        message: "no response specified"
  
  build: ( talos ) ->
    { echo } = talos.context
    talos.context.response = talos.context.echo

  options: ( talos ) ->
    { request } = talos.context
    if request.method == "options"
      talos.context.response =
        description: "no content"
        headers:
          "access-control-allow-methods": [ "*" ]
          "access-control-allow-origin": [ request.headers.origin[0] ]
          "access-control-allow-credentials": [ true ]
          "access-control-expose-headers": [ "*" ]
          "access-control-max-age": [ 7200 ]
          "access-control-allow-headers": [ "Authorization", "*" ]

  head: ( talos ) ->
    if talos.context.request.method = "head"
      talos.context.response.description = "no content"


machine = Machine.make
  start:
    parse:
      run: Parse.target
  parse:
    parseEcho: Match.echo
    default:
      run: Response.default
      move: $end
  parseEcho:
    getResponse:
      run: Parse.echo
  getResponse:
    respond: 
      run: Response.build
  respond:
    head: 
      when: Match.method "head"
      run: Response.head
      move: $end
    options:
      when: Match.method "options"
      run: Response.options
      move: $end
    default:
      move: $end


echo = ( request ) ->
  iterator = Sync.start machine, { request }
  talos = null
  for _talos from iterator
    { request: _request, rest... } = _talos.context
    console.log _talos.state, rest
    talos = _talos

  if talos.error?
    console.error talos.error
    return description: "internal server error"
  if !talos.context.response?
    console.error new Error "echo engine finished without producing response"
    return description: "internal server error"
  
  talos.context.response


export default echo