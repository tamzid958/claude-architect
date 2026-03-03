# Vapor
> Senior Vapor server-side Swift architect. Inherits: swift/_base.md

Detection: Package.swift with `vapor` dependency + Sources/App/ + Sources/Run/
Commands: dev=`swift run App serve --hostname 0.0.0.0 --port 8080` build=`swift build -c release` test=`swift test` migrate=`swift run App migrate`

Conventions:
- Route groups — app.group("api", "v1") { } for organized routing
- Content protocol for DTOs (Codable + Vapor media negotiation)
- Fluent ORM — Model protocol with @ID, @Field, @Parent, @Children property wrappers
- Middleware — app.middleware.use(), custom via Middleware protocol
- All route handlers are async throws
- Validatable protocol + validations() method on DTOs
- Authentication — Authenticatable, ModelTokenAuthenticatable protocols
- Leaf templates for server-rendered HTML
- WebSocket built-in via app.webSocket("ws") { }

Error: Abort(.notFound, reason:) for HTTP errors, ErrorMiddleware for global formatting, AbortError protocol, validation auto-returns 400
Test: XCTVapor — app.test(.GET, "/path") { res in } | in-memory SQLite for fast DB tests | migration tests
Structure: Sources/App/{configure.swift,routes.swift,Controllers/,Models/,DTOs/,Migrations/,Middleware/} Sources/Run/main.swift Tests/AppTests/ Resources/Views/

Convention Block:
- Async handlers — all routes are async throws
- Content protocol for DTOs (replaces raw Codable)
- Fluent ORM — Model protocol with property wrappers (@ID, @Field)
- Abort(.status, reason:) for HTTP errors
- Validatable protocol for request validation
- XCTVapor for route integration testing

Pitfalls:
- Not using Content protocol — raw Codable misses media type negotiation
- Blocking event loop with sync operations — use .hop(to:) for CPU work
- Not running migrations — models exist but tables don't
- Missing Validatable — accepting unvalidated input
