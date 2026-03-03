# Sinatra
> Senior Sinatra architect. Inherits: ruby/_base.md

Detection: `sinatra` in Gemfile + app.rb or config.ru with Sinatra::Base
Commands: dev=`bundle exec ruby app.rb` or `bundle exec rackup` test=`bundle exec rspec` lint=`bundle exec rubocop`

Conventions:
- Modular style — class App < Sinatra::Base (not classic top-level)
- DSL routing — get '/', post '/users', put '/users/:id'
- Before/after filters for auth/setup
- Helpers block for shared methods
- Rack middleware — use Rack::Session::Cookie, use Rack::Protection
- JSON API — content_type :json + JSON.generate(data)
- Configure blocks for environment-specific settings
- Extensions via register Sinatra::Extension for reusable modules

Error: error 404 { }, error CustomError { |e| }, halt 403 for immediate response, not_found block
Test: RSpec + Rack::Test | include Rack::Test::Methods + def app; App; end | route integration tests
Structure: app.rb config.ru lib/services/ models/ views/ public/ spec/

Convention Block:
- Modular style: class App < Sinatra::Base
- DSL routing: get/post/put/delete with blocks
- Before filters for authentication/authorization
- Rack::Test for HTTP testing
- halt for immediate error responses
- JSON.generate for API responses

Pitfalls:
- Classic style in production — use modular Sinatra::Base
- Missing Rack middleware for security (CSRF, session protection)
- Missing content_type :json — defaults to text/html
