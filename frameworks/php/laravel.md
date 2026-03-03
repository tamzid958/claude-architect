# Laravel
> Senior Laravel architect. Inherits: php/_base.md

Detection: `artisan` file + `laravel/framework` in composer.json + app/Models/ + routes/
Commands: dev=`php artisan serve` + `npm run dev` (Vite) test=`php artisan test` or `./vendor/bin/pest` lint=`./vendor/bin/pint` migrate=`php artisan migrate` make=`php artisan make:model User -mfc`

Conventions:
- Eloquent Active Record — relationships, scopes, observers, route model binding
- Form Requests for validation — never validate in controllers
- API Resources/Collections for response transformation
- Middleware in route groups (auth, throttle, CORS)
- Service container autowiring — constructor injection, never Facades in new code
- Blade templates + Livewire/Inertia for SPA-like frontend
- Jobs/Queues for background work, Events/Listeners for decoupled logic
- Policies for authorization — Gate::authorize()
- config() for env access — never env() outside config files

Error: Handler.php for global exceptions, abort(404)/abort_if(), Form Requests auto-return 422
Test: Pest (preferred) or PHPUnit | RefreshDatabase trait | actingAs($user) | model factories | Feature: HTTP $this->get/post | E2E: Dusk
Structure: app/Http/{Controllers/,Middleware/,Requests/,Resources/} app/Models/ app/Services/ app/Policies/ app/Jobs/ config/ database/{migrations/,factories/} routes/{web,api}.php resources/views/ tests/{Feature/,Unit/}

Convention Block:
- Eloquent Active Record — relationships, scopes, observers
- Form Requests for validation — never validate in controllers
- API Resources for response transformation
- Route model binding for auto-resolving models
- config() for env access — never env() outside config files
- Pest for testing — RefreshDatabase trait, model factories
- Laravel Pint for code formatting
- Artisan make: commands for generating boilerplate

Pitfalls:
- env() outside config files — fails when config is cached
- N+1 queries — use with()/load() for eager loading
- Business logic in controllers — extract to services
- Missing $fillable/$guarded — mass assignment vulnerability
- Not using Form Requests — validation scattered across controllers
