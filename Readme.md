# HTTPromise

A concise, Promise-based HTTP Request (aka AJAX) library
for your browser.

Promises are great except when your browser doesn't support them.
Thankfully, this can be fixed with a polyfill like this one:

https://www.promisejs.org/polyfills/promise-4.0.0.js

I made this for fun, and I like it. Hooray!

## Usage

Make requests like this:

```
// You can pass a type option. For now, 'json' is the only option,
// therefore you don't have to pass anything.
var http = new HTTPromise({type: 'json'}); // or just new HTTPromise;

// Call an HTTP method and pass a URL!
http.get('/whatever');

// Holy shit that was easy. What about URL params?
http.get('/whatever',{query: "how awesome is this?"});

// Neato, but where do I put my callback?
request = http.get('/whatever');
request.then(function(data,xhr){
  console.log("This is the best data:",data);
});

// O snap! Can I just chain that stuff?
var pass = function(data,xhr) { alert("FOR GREAT JUSTICE!"); };
var fail = function(xhr) { alert("TAKE UP EVERY ZIG!"); };
http.get('/whatever').then(pass).error(fail);

// Hey wait a minute, I need to post stuff!
http.post('/whatever',{any:"data",goes:"here"});

// Ok so, I'm talking to this nice API that uses meaningful
// http status codes like ---
http.get('/whatever')
  .when(200, function(data,xhr) { console.log("Got me some data!"); })
  .when(204, function() { console.log("No data here :("); });

// ZOMG! WHAT?
confirm("Yes it's amazing, can we proceed?");

// OKOK so, what all methods do I get?
http.get(url,params)
http.post(url,data)
http.put(url,data)
http.patch(url,data)
http.delete(url,data) // I guess you can send data with a delete request?
http.request(method,url,data) // If you gotta be l33t

// NOICE! and what methods are on the response object?
response = http.get('/whatever')
response.then() // always happens
response.success() // 200 status codes
response.error() // non-200 status codes, timeouts, and such
response.when(status,callback) // whatever status code you want

// for reals how have I lived without this my whole life?
http.takesBow()

// ^ lol that's not a real function don't try calling it.
```

## Extension

I pretty much don't care about old browsers or XML. If you DO, then
you could add a config object to define some other kind of request format.
For instance:

```
HTTPromiseFormat.xml = {
  headers: {
    'Content-Type':'application/xml',
    'Accept':'application/xml'
  },
  encode: function(data) {
    // make your data ready to send
    return output;
  },
  parse: function(xhr) {
    // read the server response here
    return {data: myDataObject, xhr: xhr}
  }
}
```

## Development / Testing

The docs are in JS, just because. I wrote this in CoffeeScript,
which I personally like better. You'll need TestEm installed to
build/run the project, because using the test runner as a sort of
build-tool has the nice side effect of making it a lot harder to
skip writing tests. You'll also want to run the little sinatra app
that's attached so you have something to send test requests too.
I might redo that in Node later but, I built this one night when
I was bored, so, who knows.

## Compatibility

I just wrote this in Chrome, I haven't tested other browsers yet.
If I decide to actually use this someplace I'll test the other
browsers at that point. In theory it should be awesome in Firefox,
and should work in Safari and Opera and IE 11 with the Promise Polyfill,
as well as whatever IE version added XmlHttpRequest rather than
Microsoft's version.

## License

HTTP Promise is distributed under the MIT License. Copyright (c) 2014 Andrew Burleson.

PS, if you do something neat with it, I'd love to know :)
