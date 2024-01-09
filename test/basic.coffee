import assert from "@dashkite/assert"
import authorization from "./authorization"

test = ( h ) ->
  [
    h.test "ok", ->
      response = await h.request "get", "/", {},
        description: "ok"
        content:
          hello: "world"
        headers:
          "content-type": [ "application/json" ]

      assert.equal 200, response.status
      json = await response.json()
      assert.equal "world", json.hello
      
    h.test "unauthorized", ->
      content = 
        $echo: true
        message: "You don't have what you need yet."
      authenticate = "https://www.dashkite.com"
      path = "/bunch/of/ignored/stuff"

      response = await h.request "get", path, {},
        description: "unauthorized"
        content: content
        headers:
          "content-type": [ "application/json" ]
          "WWW-Authenticate": [ "https://www.dashkite.com" ]

      assert.equal 401, response.status
      assert.equal authenticate, response.headers.get "www-authenticate"
      json = await response.json()
      assert.equal content.message, json.message

    h.test "rune", ->
      response = await h.rune "get", authorization

      assert.equal 200, response.status
      json = await response.json()
      assert json.rune?
      assert json.nonce?

  ]


export default test