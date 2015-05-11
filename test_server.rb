require 'thin'
require 'sinatra'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/dist'

def json(hash)
  headers "Content-Type" => "application/json"
  JSON.generate(hash)
end

def parse(s)
  JSON.parse(s)
end

before do
  headers "Access-Control-Allow-Origin" => "*"
  headers "Access-Control-Allow-Methods" => "GET, POST, PUT, PATCH, DELETE, OPTIONS"
  headers "Access-Control-Allow-Headers" => "Accept, Content-Type"
end

# Sandbox Page
get('/') { erb :index }

# Method Tests
get('/test')     { json({echo: params}) }
post('/test')    { json({echo: parse(request.body.read)}) }
put('/test')     { json({echo: parse(request.body.read)}) }
patch('/test')   { json({echo: parse(request.body.read)}) }
delete('/test')  { 200 }

# Form Tests
post('/formdata') { json(params) }

# Status Tests
get('/204') { 204 }
get('/500') do
  status 500
  json({error: "Something went wrong"})
end
# CORS Fun
options('/*') {}

__END__

@@ index
<!DOCTYPE html>
<html>
  <head>
    <title>HTTP Request Test Page</title>
  </head>
  <body>
    <p>HTTP Request Test Page</p>
    <script src="https://www.promisejs.org/polyfills/promise-6.1.0.min.js"></script>
    <script src="httpromise.js"></script>
    <script>
      h = new HTTPromise
    </script>
    <form id="test">
      <label for="a">Test</label>
      <input id="a" name="a" type="text" value="hello">
    </form>
  </body>
</html>
