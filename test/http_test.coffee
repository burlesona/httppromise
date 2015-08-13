assert = chai.assert
url = (path) -> "http://localhost:4567/#{path}"

describe "GET Requests", ->
  http = new HTTPromise
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
    r('500').error (data,xhr) ->
      assert true
      done()

  it "should return data, xhr for success", (done) ->
    r().success (data,xhr) ->
      assert data
      assert xhr
      done()

  it "should return data, xhr for error", (done) ->
    r('500').error (data,xhr) ->
      assert data
      assert xhr
      done()

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "Configuration", ->
  it "should configurable to add a header", (done) ->
    http = new HTTPromise(headers:{'X-Requested-With': 'XMLHttpRequest'})
    http.get(url('/xhr')).then (data, xhr) ->
      assert.equal 200, xhr.status
      done()

  it "should give a useful error message with improper header", (done) ->
    http = new HTTPromise(headers:'XMLHttpRequest')
    test = -> http.get(url('/xhr'))
    assert.throws(test,TypeError)
    done()


describe "POST Requests", ->
  http = new HTTPromise
  r = (path="test",data) -> http.post(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "PUT Requests", ->
  http = new HTTPromise
  r = (path="test",data) -> http.put(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "PATCH Requests", ->
  http = new HTTPromise
  r = (path="test",data) -> http.patch(url(path),data)

  it "should send URL params", (done) ->
    r('test',{foo: 'bar'}).then (data, xhr) ->
      assert.deepEqual data, {echo: {foo: 'bar'}}
      done()

describe "DELETE Requests", ->
  http = new HTTPromise
  r = (path="test",data) -> http.delete(url(path),data)

  it "should delete stuff", (done) ->
    r('test').then (data, xhr) ->
      assert.equal xhr.status, 200
      done()

# FormData adapter
describe "FormData adapter", ->
  withForm = (callback) ->
    formHTML = """
      <form id="test-form">
        <input id="a" type="text" name="input[a]" value="Hello"></input>
        <input id="b" type="text" name="input[b]" value="World"></input>
        <button>Submit</button>
      </form>
    """
    div = document.createElement('div')
    div.innerHTML = formHTML
    document.body.appendChild(div)
    callback()
    div.remove()

  it "should setup a test form correctly", ->
    withForm ->
      a = document.getElementById('a')
      b = document.getElementById('b')
      assert.equal 'Hello', a.value
      assert.equal 'World', b.value

  it "should serialize form data correctly", (done) ->
    http = new HTTPromise(type: 'formData')
    withForm ->
      request = http.post url('formdata'), document.getElementById('test-form')
      request.then (data,xhr) ->
        assert.equal xhr.status, 200
        d = JSON.parse(xhr.response)
        assert.equal "Hello", d.input.a
        assert.equal "World", d.input.b
        done()

  it "should work with a form selector", (done) ->
    http = new HTTPromise(type: 'formData')
    withForm ->
      request = http.post url('formdata'), '#test-form'
      request.then (data,xhr) ->
        assert.equal xhr.status, 200
        d = JSON.parse(xhr.response)
        assert.equal "Hello", d.input.a
        assert.equal "World", d.input.b
        done()

