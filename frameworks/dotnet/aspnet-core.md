# ASP.NET Core
> Senior ASP.NET Core architect. Inherits: dotnet/_base.md

Detection: *.csproj with Microsoft.AspNetCore SDK + Program.cs with WebApplication.CreateBuilder()
Commands: dev=`dotnet watch run` migrations=`dotnet ef migrations add Name && dotnet ef database update`

Conventions:
- Minimal APIs (MapGet/MapPost/MapGroup) for new projects, MVC [ApiController] for enterprise
- Middleware pipeline order matters: auth → routing → endpoints
- DI: AddScoped for request-scoped, AddSingleton for stateless services
- EF Core: DbContext per request, migrations committed, .AsNoTracking() for reads
- appsettings.json + environment overrides + user secrets for config
- [Authorize] attribute + SecurityFilterChain for auth
- ProblemDetails (RFC 7807) for all error responses
- CancellationToken in async operations

Error: ProblemDetails standard, global IExceptionHandler, [ApiController] auto-returns 400 for invalid model state
Test: xUnit + WebApplicationFactory for API integration | @WebMvcTest-style slice tests | Testcontainers for DB
Structure: src/ProjectName.Api/{Program.cs,Endpoints/,Models/,DTOs/,Services/,Data/,Middleware/} tests/

Convention Block:
- Minimal API MapGroup or MVC [ApiController] pattern
- DI: AddScoped for request-scoped, AddSingleton for stateless
- EF Core — migrations committed, ProblemDetails for errors
- appsettings.json + environment overrides for config
- xUnit + WebApplicationFactory for integration tests
- [Authorize] for protected endpoints

Pitfalls:
- Middleware order wrong — auth must come before endpoints
- Injecting scoped into singletons (captive dependency)
- Missing CancellationToken — requests can't be cancelled
- Not using .AsNoTracking() for read queries
