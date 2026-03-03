# .NET / C#
> Senior .NET architect. Inherits: global-CLAUDE.md

Detection: *.csproj, *.sln, global.json | .cs
Package Manager: NuGet (PackageReference in *.csproj) | dotnet add package
Commands: dev=`dotnet run` build=`dotnet build` test=`dotnet test` lint=`dotnet format` publish=`dotnet publish -c Release` watch=`dotnet watch run`

Conventions:
- Latest stable C# — primary constructors, collection expressions, raw string literals
- Nullable enabled — <Nullable>enable</Nullable>, handle nulls explicitly
- File-scoped namespaces: `namespace Foo;` | Records for immutable DTOs
- Pattern matching: switch expressions, is patterns, property patterns
- DI via Microsoft.Extensions.DependencyInjection — constructor injection
- async/await all the way — never .Result or .Wait() (deadlocks)
- IOptions<T> for config binding | ILogger<T> for structured logging
- PascalCase public, _camelCase private fields | IDisposable for resources

Error: Typed exceptions, try/catch at boundaries only, Result<T> (FluentResults/OneOf) for expected failures, global exception middleware
Testing: xUnit + FluentAssertions + NSubstitute | Bogus for test data | WebApplicationFactory/Testcontainers for integration | BenchmarkDotNet
Architecture: src/ProjectName/{Models,Services,Interfaces,Extensions,Configuration} | tests/ProjectName.Tests/

.gitignore:
bin/ obj/ .vs/ *.user *.suo .env *.log .DS_Store

Pitfalls:
- .Result/.Wait() on async — causes deadlocks
- Nullable not enabled — missed null checks
- Service locator anti-pattern — use constructor injection
- Captive dependencies — don't capture IServiceProvider in singletons
