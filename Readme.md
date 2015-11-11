# HTTPromise

*Version 1.1.1* (see changelog below)

A concise, Promise-based HTTP Request (aka AJAX) library
for your browser.

Promises are great except when your browser doesn't support them.
Thankfully, this can be fixed with a [polyfill](https://www.promisejs.org/)
like this one:

[https://www.promisejs.org/polyfills/promise-7.0.1.js](https://www.promisejs.org/polyfills/promise-7.0.1.js)

I made this for fun, and I like it. I've been using it in production for about a year,
and it's been great. I keep it working nicely because I need it all the time, and if you
use this and run into an issue I'll do my best to help you out.

## Quick-Start

Make requests like this:

```
// You can pass a type option. Default types are 'json' and 'formData'
// 'json' is the default, therefore you don't have to pass anything.
var http = new HTTPromise({type: 'json'});
var http = new HTTPromise; // same thing.

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

## Custom Request Formats

I'm keen on moving past old browsers, and not fond of XML. But if you want to tackle
those beasts, you could easily add a new format aimed at them.

To do this, you need to add a format property to the HTTPromiseRequestFormat object.
A "format" needs properties: `headers`, `encode`, and `parse`.

In the minimum case these can be no-ops. For instance:

```
HTTPPromiseFormat.nothin = {
  headers: {},
  encode: function(data) { return data; }
  parse: function(xhr) { return xhr; }
}
```

In this case:

1. There will be no headers on the request.

2. Whatever you pass in as data will be be passed directly to the `XMLHttpRequest` instance's `send` method.

3. The xhr response object will be returned to your promises as-is.

This all happens in the HTTPPromise Request object's constructor, and is pretty straightforward,
so please just check the source code to see the default types and what all happens under the hood,
then feel free to extend this however you like.

## Per-Instance Headers

In addition to the `type` option, you can also pass a `headers` option to the HTTPromise constructor.
For example:

```js
var http = new HTTPromise({type:'json',headers:{'X-Client-ID':'cl_6251523'}})
```

If you pass the `headers` option it must be an object where they keys and values represent headers.

These headers will be added to the default headers for the request format you're using.

## About the X-HTTP-Requested-With Header

The [X-HTTP-Requested-With](https://en.wikipedia.org/wiki/List_of_HTTP_header_fields#Common_non-standard_request_fields)
header is non-standard but used by jQuery and therefore ubiquitous. This means a lot of server-side libraries
and frameworks, such as Ruby's Rack framework, provide convenience methods for checking this header,
and a lot of code relies on these convenience methods to determine if a request is "ajax" or not.

Since this header is not standard, the browsers don't set it, and neither does HTTPromise. But that means
that if you are, for example, using a ruby rack-based webserver and you write a method like this:

```ruby
if request.xhr?
  # send some json
else
  # send some html
```

... then HTTPromise is going to get the HTML by default, which may surprise you.

You have two choices here:

1. Check for the request "Accept" header instead. Since your JSON requests should
   not accept HTML, your server should not send HTML. This is the standards-compliant
   way to go, and it's what I do.

2. Add the `X-HTTP-Requested-With` header to your requests. This will make your
   requests look more like they come from jQuery, which will make more server frameworks
   recognize them as ajax "automatically." Personally, I think this is not as good
   of a solution, but it is probably an easier "hack" for many systems.

If you want to add this header to all requests from a particular HTTPromise instance,
just pass it into the constructor:

```js
var http = new HTTPromise({type:'json',headers:{'X-HTTP-Requested-With':'XMLHttpRequest'})
```



## Development / Testing

The docs are in JS and the distribution is as well.
I wrote this library in CoffeeScript, which I personally like better.
You'll need [TestEm](https://github.com/airportyh/testem) installed
to build/run the project, because using the test runner as a sort of
build-tool has the nice side effect of making it a lot harder to skip
writing tests. You'll also want to run the little sinatra app that's
attached so you have something to send test requests too. I might redo
that in Node later, but who knows...

## Compatibility

With the Promise Polyfill, this has been tested and works all the
real browsers, plus Internet Explorer >= 9.0.

This is the polyfill I use in my production environments:
```
<script src="https://www.promisejs.org/polyfills/promise-7.0.1.min.js"></script>
```

## License

HTTP Promise is distributed under the MIT License.
Copyright (c) 2014-2015 Andrew Burleson.

PS, if you do something neat with it, I'd love to know. You can open an issue
on this repo to tell me about it, and I might even feature your project on
the readme :)

## Changelog

*Version 1.1.1 (November 11, 2015)*
- Merge PR from Travis Nesland to fix issue of HTTPromiseRequestFormat not being found when lib is loaded through NPM.
- Update dist and package.json

*Version 1.1 (August 13, 2015)*
- Add config option to set request headers per instance
- Update development dependencies

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
