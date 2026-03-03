# Ktor
> Senior Ktor architect. Inherits: kotlin/_base.md

Detection: io.ktor in build.gradle.kts + Application.kt with embeddedServer() or Application.module()
Commands: dev=`./gradlew run` (with auto-reload) fatjar=`./gradlew buildFatJar`

Conventions:
- Plugin-based: install(ContentNegotiation), install(Authentication), install(StatusPages)
- Routing DSL: routing { get("/users") { } } with nested routes
- Coroutine-native — all handlers are suspend functions
- Kotlinx.serialization: @Serializable data classes for request/response
- call.receive<T>() for input, call.respond(data) for output
- Application modules: fun Application.module() for modular setup
- application.conf (HOCON) for configuration

Error: StatusPages plugin for global exception → response mapping, custom exceptions caught automatically
Test: testApplication { } DSL for in-process testing — client.get/post inside test block
Structure: src/main/kotlin/com/app/{Application.kt,plugins/,routes/,models/,services/,repositories/} src/test/

Convention Block:
- Plugin-based — install() for features
- Routing DSL with typed receive/respond
- Coroutine-native — all handlers suspend
- Kotlinx.serialization — @Serializable DTOs
- StatusPages for error handling
- testApplication {} for integration testing

Pitfalls:
- Not installing ContentNegotiation — call.receive() fails silently
- No StatusPages — unhandled exceptions return empty 500
- Blocking coroutines with sync I/O — use withContext(Dispatchers.IO)
- Real server in tests instead of testApplication — slow
