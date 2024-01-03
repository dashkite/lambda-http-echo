test = ( h ) ->
  [
    h.test "ok", ->
      response = await h.request "get", "/",
        description: "ok"
        content:
          $echo: true
          hello: "world"
        headers:
          "content-type": [ "application/json" ]

      h.assert.equal 200, response.status
      json = await response.json()
      h.assert.equal "world", json.hello
      
    h.test "unauthorized", ->
      content = 
        $echo: true
        message: "You don't have what you need yet."
      authenticate = "https://www.dashkite.com"
      path = "/bunch/of/ignored/stuff"

      response = await h.request "get", path,
        description: "unauthorized"
        content: content
        headers:
          "content-type": [ "application/json" ]
          "WWW-Authenticate": [ "https://www.dashkite.com" ]

      h.assert.equal 401, response.status
      h.assert.equal authenticate, response.headers.get "www-authenticate"
      h.assert.equal path, response.headers.get "x-echo-path"
      json = await response.json()
      h.assert.equal path, json.$echo.path
      h.assert.equal content.message, json.message

  ]


export default test