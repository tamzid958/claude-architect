# Go Web Frameworks
> Senior Go web architect. Inherits: go/_base.md

## Gin
Detection: `github.com/gin-gonic/gin` in go.mod
Conventions:
- Handlers: `func(c *gin.Context)` — extract, validate, respond
- Route groups: `r.Group("/api/v1")` for versioned APIs
- Binding: `c.ShouldBindJSON(&dto)` with `binding:"required"` struct tags — never use `c.Bind()` (aborts on error)
- Context values: `c.Set()`/`c.Get()` for passing data through middleware
- Response: `c.JSON(200, gin.H{})`, `c.AbortWithStatusJSON()` for errors

Error: `c.AbortWithStatusJSON(status, gin.H{"error": msg})` + custom error middleware via `c.Errors` collection

Pitfalls:
- `c.Bind()` vs `c.ShouldBind()` — Bind aborts on error, ShouldBind returns it
- Not calling `c.Abort()` after error response — handler continues executing
- Missing `gin.Recovery()` middleware — panics crash the server

## Echo
Detection: `github.com/labstack/echo` in go.mod
Conventions:
- Handlers: `func(c echo.Context) error` — always return error
- Binding: `c.Bind(&dto)` with struct tags + custom `echo.Validator` for validation
- Centralized errors: custom `e.HTTPErrorHandler` for global error formatting
- Context extension: custom context type for request-scoped data
- Built-in middleware: Logger, Recover, CORS, JWT, RateLimiter

Error: Return `echo.NewHTTPError(status, message)` — Echo handles the response via HTTPErrorHandler

Pitfalls:
- Forgetting to return error from handler — error swallowed silently
- Not setting custom HTTPErrorHandler — default may expose internals
- Using `c.Bind()` without validation — accepts any shape

## Fiber
Detection: `github.com/gofiber/fiber` in go.mod
Conventions:
- Handlers: `func(c *fiber.Ctx) error` — Express-inspired API on fasthttp
- NOT `net/http` compatible — fasthttp uses different request/response types
- Body parsing: `c.BodyParser(&dto)`, params: `c.Params("id")`, `c.Query("page")`
- Response: `c.Status(code).JSON(data)`, `c.SendString()`
- Custom error handler via `fiber.Config{ErrorHandler: func}` on app creation

Error: Return `fiber.NewError(status, message)` + custom `ErrorHandler` in `fiber.Config`

Pitfalls:
- Assuming `net/http` compatibility — Fiber uses fasthttp, different interfaces
- Accessing request body after handler returns — fasthttp reuses buffers
- Not returning `nil` from successful handlers — breaks middleware chain

## Shared
Commands: same as _base.md + `air` for live reload
Test: `go test` + `httptest` (Gin/Echo) or `app.Test(req)` (Fiber) | Unit: services | Integration: handler tests
Structure: `cmd/api/main.go` `internal/{handler,service,repository,model,middleware,dto,config}`

Convention Block (Gin):
- Route groups for API versioning — `r.Group("/api/v1")`
- `ShouldBindJSON` for request binding — struct tags for validation
- Handler -> Service -> Repository layer pattern
- `gin.Recovery()` + custom error middleware for error handling
- `c.AbortWithStatusJSON` for error responses
- `httptest` for handler integration tests

Convention Block (Echo):
- Handler signature: `func(echo.Context) error` — always return error
- Route groups for API organization — `e.Group()`
- Custom `HTTPErrorHandler` for centralized error formatting
- `c.Bind` for request binding, custom `echo.Validator` for validation
- Handler -> Service -> Repository pattern
- `httptest` for integration testing

Convention Block (Fiber):
- Fiber (fasthttp-based) — NOT `net/http` compatible
- Handler: `func(*fiber.Ctx) error` — return `fiber.NewError` for errors
- `c.BodyParser` for request binding
- Custom `ErrorHandler` in `fiber.Config` for global errors
- `app.Test(req)` for integration testing — no HTTP server needed
- Handler -> Service -> Repository pattern
