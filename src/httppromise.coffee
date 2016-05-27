RequestFormat =
  json:
    headers:
      'Content-Type':'application/json'
      'Accept':'application/json'
    encode: (data) ->
      try str = JSON.stringify(data)
      str
    parse: (xhr) ->
      try data = JSON.parse(xhr.response)
      {data: data, xhr: xhr}

  formData:
    encode: (input) ->
      form = if typeof input is 'string'
        document.querySelector(input)
      else
        input
      new FormData(form)
    parse: (xhr) ->
      {data: xhr.response, xhr: xhr}

class HttpPromise
  @format: (name) ->
    RequestFormat[name]
  @setFormat: (name,options) ->
    RequestFormat[name] = options

  constructor: (config = {}) ->
    @config = config
    @config.type or= 'json'

  get: (url,params) ->
    if params
      q = []
      q.push("#{k}=#{v}") for k,v of params
      qs = "?" + q.join('&')
      url = encodeURI(url+qs)
    @request 'get', url

  post: (url,data) -> @request 'post', url, data
  put: (url,data) -> @request 'put', url, data
  patch: (url,data) -> @request 'patch', url, data
  delete: (url,data) -> @request 'delete', url, data

  request: (method,url,data) ->
    new Request @config, method, url, data

class Request
  constructor: (config,method,url,data) ->
    format = RequestFormat[config.type]
    if config.headers? and typeof config.headers isnt "object"
      throw new TypeError("If given, headers must an object where each key value pair represents a request header")

    @promise = new Promise (fulfill,reject) ->
      request = new XMLHttpRequest
      request.onload = ->
        fulfill format.parse(this)
      request.onerror = ->
        reject state: "ERROR", xhr: this
      request.onabort = ->
        reject state: "ABORT", xhr: this
      request.ontimeout = ->
        reject state: "TIMEOUT", xhr: this
      request.open method.toUpperCase(), url, true
      for k,v of format.headers
        request.setRequestHeader(k,v)

      if config.headers
        for k,v of config.headers
          request.setRequestHeader(k,v)

      if data
        request.send format.encode(data)

      else
        request.send()

  then: (fn) ->
    @promise.then (r) ->
      fn(r.data, r.xhr)
    this

  when: (status,fn) ->
    @promise.then (r) ->
      fn(r.data, r.xhr) if r.xhr.status is status
    this

  success: (fn) ->
    @promise.then (r) ->
      fn(r.data, r.xhr) if (r.xhr.status >= 200 and r.xhr.status < 300)
    this

  error: (fn) ->
    # If the request returns a non 200 status, this is "fulfilled" but an error
    fulfill = (r) ->
      fn(r.data, r.xhr) if r.xhr.status < 200 or r.xhr.status >= 300

    # If the request is not fulfilled (errors etc.)
    reject = (r) ->
      fn(r.data, r.xhr)
    @promise.then(fulfill,reject)
    this

# Module Exports or define on window
if module?
  module.exports = HttpPromise
else
  window.HttpPromise = HttpPromise
