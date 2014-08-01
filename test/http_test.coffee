assert = chai.assert
url = (path) -> "http://localhost:4567/#{path}"

describe "GET Requests", ->
  http = new HTTPHandler
  r = (path="test",params) -> http.get(url(path),params)

  it "should get '/test'", (done) ->
    r().then (data,xhr) ->
      assert.equal xhr.status, 200
      done()

  it "should trigger success after /test", (done) ->
    r().success (data,xhr) ->
      assert.ok true
      done()

  it "should trigger when 200 after /test", (done) ->
    r().when 200, (data,xhr) ->
      assert true
      done()

  it "should trigger error on response not in 200 range", (done) ->
    r('500').error (r) ->
      assert true
      done()

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "POST Requests", ->
  http = new HTTPHandler
  r = (path="test",data) -> http.post(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "PUT Requests", ->
  http = new HTTPHandler
  r = (path="test",data) -> http.put(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "PATCH Requests", ->
  http = new HTTPHandler
  r = (path="test",data) -> http.patch(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "DELETE Requests", ->
  http = new HTTPHandler
  r = (path="test",data) -> http.delete(url(path),data)

  it "should delete stuff", (done) ->
    r('test').then (data, xhr) ->
      assert.equal xhr.status, 200
      done()
