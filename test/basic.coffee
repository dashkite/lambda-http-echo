test = ( h ) ->
  [
    h.test "ok", ->
      response = await h.request "get", "/",
        description: "ok"
        content: JSON.stringify hello: "world"
        headers:
          "content-type": [ "application/json" ]

      h.assert.equal 200, response.status
      h.assert.deepEqual hello: "world", await response.json()
      
    h.test "unauthorized", ->
      content = "You don't have what you need yet."
      authenticate = "https://www.dashkite.com"

      response = await h.request "get", "/bunch/of/ignored/stuff",
        description: "unauthorized"
        content: content
        headers:
          "WWW-Authenticate": [ "https://www.dashkite.com" ]

      h.assert.equal 401, response.status
      h.assert.equal authenticate, response.headers.get "www-authenticate"
      h.assert.deepEqual content, await response.text()

  ]


export default test