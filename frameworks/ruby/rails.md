# Ruby on Rails
> Senior Rails architect. Inherits: ruby/_base.md

Detection: Gemfile with `rails` + config/routes.rb + bin/rails + app/models/
Commands: dev=`bin/rails server` or `bin/dev` test=`bin/rails test` or `bundle exec rspec` lint=`bundle exec rubocop` migrate=`bin/rails db:migrate` console=`bin/rails console` generate=`bin/rails generate model User name:string`

Conventions:
- Convention over configuration — follow Rails naming exactly
- Fat models, thin controllers — concerns and service objects for complexity
- RESTful resources — `resources :users` with 7 standard actions
- Active Record — has_many, belongs_to, validates, scopes, callbacks
- Concerns for shared behavior (ActiveSupport::Concern modules)
- Service objects in app/services/ for complex business logic
- Strong parameters — params.require(:user).permit(:name, :email)
- Turbo + Stimulus (Hotwire) for modern frontend
- Active Job for background jobs, Action Mailer for emails
- Credentials — bin/rails credentials:edit for encrypted secrets

Error: rescue_from in controllers, RecordNotFound auto-404, custom error pages in public/, transaction blocks
Test: RSpec (preferred) or Minitest | FactoryBot + Faker | Capybara for system tests | Shoulda Matchers | request specs for HTTP
Structure: app/{controllers/,models/,views/,services/,jobs/,mailers/,helpers/} config/{routes.rb,database.yml} db/{migrate/,schema.rb,seeds.rb} spec/{models/,requests/,system/,factories/}

Convention Block:
- RESTful resources — 7 standard actions, nested resources when related
- Fat models, thin controllers — concerns and service objects for complexity
- Active Record for ORM — validations, scopes, callbacks, associations
- Strong parameters in controllers — never trust raw params
- RSpec + FactoryBot + Capybara for testing
- Migrations committed — never edit schema.rb by hand
- Hotwire (Turbo + Stimulus) for modern frontend
- Credentials for secrets — never commit plain env vars

Pitfalls:
- N+1 queries — use includes()/eager_load() for associations
- Business logic in controllers — extract to models/services/concerns
- Not using strong parameters — mass assignment vulnerability
- Editing schema.rb by hand instead of writing migrations
- Callbacks growing complex — extract to service objects
- Direct `rails` instead of `bin/rails` — wrong version
