# HTTPromise

*Version 1.0* (see changelog below)

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

// Woah, that was easy. What about URL params?
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

// NICE! and what methods are on the response object?
response = http.get('/whatever')
response.then() // always happens
response.success() // 200 status codes
response.error() // non-200 status codes, timeouts, and such
response.when(status,callback) // whatever status code you want

// for reals how have I lived without this my whole life?
http.takesBow()

// ^ lol that's not a real function don't try calling it.
```

## Built-In Types

HTTPromise knows about two kinds of requests by default: JSON and FormData.
If you don't specify a type, JSON is the default. You can make FormData requests
like so:

```
var http = new HTTPromise({type: 'formData'});
var form = document.getElementById('my-form');
http.post('/formdata',form).then(function(data,xhr){console.log(data,xhr)});
```

The form data is generated from the second argument. You can pass a form element
or a selector string. Note that if you input a selector it will be passed to
`document.querySelector`, therefore only the first match will be passed on to
`FormData`. Use a unique selector, IDs are recommended.

Example HTML

```html
<form id="my-form">
  <input name="test" type="text" value="foo">
</form>
```

Example JS

```js
var http = new HTTPromise({type: 'formData'});
http.post('/formdata','#my-form').then(function(data,xhr){console.log(data,xhr)});
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

With the Promise Polyfill, this has been tested and works all the
real browsers, plus Internet Explorer >= 9.0.

This is the polyfill I use in my production environments:
```
<script src="https://www.promisejs.org/polyfills/promise-6.1.0.min.js"></script>
```

## License

HTTP Promise is distributed under the MIT License. Copyright (c) 2014 Andrew Burleson.

PS, if you do something neat with it, I'd love to know. :)

## Changelog

*Version 1.0 (May 11, 2015)*
- Start Versioning
- Change error response to deliver consistent two argument return rather than a single object payload.

*Version 0.x Part 2*
- Add FormData request type

*Version 0.x* (August 2014 - Feb 2014)
- Write this
- Test it
- Use it in production
- Love it
- High-fives all around
