# Rust Web Frameworks
> Senior Rust web architect. Inherits: rust/_base.md

## Actix Web
Detection: `actix-web` in Cargo.toml
Conventions:
- Extractors: web::Json<T>, web::Path<T>, web::Query<T> for typed parsing
- web::Data<AppState> for shared state (DB pools, config)
- web::scope("/api") for route groups, configure() for modular setup
- wrap() for middleware, #[get("/")]/macro routing or web::resource()
Error: Implement ResponseError trait on custom error types
Pitfalls:
- Not registering services in App::new() config
- Blocking async runtime with sync I/O — use web::block()
- Not implementing ResponseError — unhelpful default errors

## Axum
Detection: `axum` in Cargo.toml
Conventions:
- Extractors as handler params: Json<T>, Path<T>, Query<T>, State<T>
- Body extractors (Json) must be last parameter — compile error otherwise
- Tower middleware via ServiceBuilder layers (CORS, tracing, rate limiting)
- Router::nest("/api", sub_router) for modular routing
- State requires Clone — use Arc for expensive types
Error: Implement IntoResponse on custom error types, return (StatusCode, Json<E>)
Pitfalls:
- Body extractor not last param — compile error
- Missing Clone on state types
- Forgetting #[derive(Deserialize)] on extractor types

## Rocket
Detection: `rocket` in Cargo.toml
Conventions:
- Attribute routing: #[get("/path/<param>")], #[post("/path")]
- Request guards for type-safe extraction + validation before handler
- Fairings for middleware (request/response lifecycle)
- Managed state: rocket.manage(state) + &State<T> in handlers
- #[catch(404)] for error page handlers | Rocket.toml for config
Error: #[catch(status)] handlers, Result<T, Status>, custom Responder implementations
Pitfalls:
- Not mounting routes with routes![] macro — handler unreachable
- Missing FromForm/Deserialize derives on request types

## Shared
Commands: same as _base.md + `cargo watch -x run` for live reload
Test: cargo test + framework test utilities | Unit: services | Integration: handler tests with test client
Structure: src/{main.rs,config.rs,routes/,handlers/,models/,services/,middleware/,errors.rs,db.rs} tests/

Convention Block (Actix Web):
- Extractors (web::Json, Path, Query) for typed parsing
- web::Data<AppState> for shared state
- ResponseError trait on custom error types
- web::scope + configure() for modular routes

Convention Block (Axum):
- Extractors as handler params — Json<T> must be last
- Tower middleware via ServiceBuilder layers
- IntoResponse on custom error types
- Router::nest for modular sub-routers

Convention Block (Rocket):
- Attribute routing: #[get], #[post] with typed params
- Request guards for validation, State<T> for shared state
- #[catch(status)] for error handlers
- Rocket.toml for config, rocket::local::Client for testing
