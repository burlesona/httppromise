root = exports ? this

root.HTTPRequestFormat =
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

class root.HTTPHandler
  constructor: (config = {}) ->
    @config = config
    @type = config.type or 'json'

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
    new Request @type, method, url, data

class Request
  constructor: (type,method,url,data) ->
    format = HTTPRequestFormat[type]
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
    fulfill = (r) ->
      fn(r) if r.xhr.status < 200 or r.xhr.status >= 300
    reject = (r) ->
      fn(r)
    @promise.then(fulfill,reject)
    this
