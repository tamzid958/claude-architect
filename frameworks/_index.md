# Framework Detection Matrix

Identify project language and framework from config files and dependencies.

## Detection Order
1. Config files (most specific)
2. Dependencies in package/manifest files
3. File extensions and directory patterns

## Config File → Framework Mapping

### TypeScript / JavaScript
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `next.config.*` | `next` | Next.js | `typescript/nextjs.md` |
| `nuxt.config.*` | `nuxt` | Nuxt | `typescript/nuxt.md` |
| `svelte.config.js` + `src/routes/` | `@sveltejs/kit` | SvelteKit | `typescript/sveltekit.md` |
| `svelte.config.js` (no routes/) | `svelte` | Svelte | `typescript/svelte.md` |
| `astro.config.*` | `astro` | Astro | `typescript/astro.md` |
| `remix.config.js` / vite+remix | `@remix-run/node` | Remix | `typescript/remix.md` |
| `vite.config.*` + `src/App.vue` | `vue` | Vue | `typescript/vue.md` |
| `src/App.tsx` (no next/remix) | `react` + `react-dom` | React SPA | `typescript/react.md` |
| `src/main.ts` + `NestFactory` | `@nestjs/core` | NestJS | `typescript/nestjs.md` |
| — | `hono` in package.json | Hono | `typescript/api.md` |
| — | `express` in package.json | Express | `typescript/api.md` |
| `package.json` only | — | Vanilla TS/JS | `typescript/_base.md` |

### Python
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `manage.py` + `settings.py` | `django` | Django | `python/django.md` |
| `main.py` + `FastAPI()` | `fastapi` | FastAPI | `python/fastapi.md` |
| `app.py` + `Flask` | `flask` | Flask | `python/flask.md` |
| `scrapy.cfg` / `BOT_NAME` | `scrapy` | Scrapy | `python/scrapy.md` |
| `pyproject.toml` / `requirements.txt` | — | Vanilla Python | `python/_base.md` |

### Go
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `go.mod` | `gin-gonic/gin` | Gin | `go/web.md` |
| `go.mod` | `labstack/echo` | Echo | `go/web.md` |
| `go.mod` | `gofiber/fiber` | Fiber | `go/web.md` |
| `go.mod` (no framework) | `net/http` | Go stdlib | `go/_base.md` |

### Rust
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `Cargo.toml` | `actix-web` | Actix Web | `rust/web.md` |
| `Cargo.toml` | `axum` | Axum | `rust/web.md` |
| `Cargo.toml` | `rocket` | Rocket | `rust/web.md` |
| `Cargo.toml` + `src-tauri/` | `tauri` | Tauri | `rust/tauri.md` |
| `Cargo.toml` (no web) | — | Vanilla Rust | `rust/_base.md` |

### C# / .NET
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `*.csproj` + `WebApplication` | `Microsoft.AspNetCore` | ASP.NET Core | `dotnet/aspnet-core.md` |
| `*.csproj` + `.razor` files | `AspNetCore.Components` | Blazor | `dotnet/blazor.md` |
| `*.csproj` + `MauiProgram.cs` | `Microsoft.Maui` | .NET MAUI | `dotnet/maui.md` |
| `*.csproj` / `*.sln` only | — | Vanilla .NET | `dotnet/_base.md` |

### Java
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `pom.xml` / `build.gradle` | `spring-boot-starter` | Spring Boot | `java/spring-boot.md` |
| `pom.xml` / `build.gradle` | `io.quarkus` | Quarkus | `java/quarkus.md` |
| `pom.xml` / `build.gradle` only | — | Vanilla Java | `java/_base.md` |

### Kotlin
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `build.gradle.kts` | `io.ktor` | Ktor | `kotlin/ktor.md` |
| `build.gradle.kts` only | — | Vanilla Kotlin | `kotlin/_base.md` |

### PHP
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `artisan` + `composer.json` | `laravel/framework` | Laravel | `php/laravel.md` |
| `composer.json` + `symfony.lock` | `symfony/framework-bundle` | Symfony | `php/symfony.md` |
| `composer.json` only | — | Vanilla PHP | `php/_base.md` |

### Ruby
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `Gemfile` + `config/routes.rb` | `rails` | Rails | `ruby/rails.md` |
| `Gemfile` + `config.ru` + Sinatra | `sinatra` | Sinatra | `ruby/sinatra.md` |
| `Gemfile` only | — | Vanilla Ruby | `ruby/_base.md` |

### Swift
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `*.xcodeproj` + SwiftUI imports | SwiftUI | SwiftUI | `swift/swiftui.md` |
| `Package.swift` + Sources/ | `vapor` | Vapor | `swift/vapor.md` |
| `Package.swift` / `*.xcodeproj` | — | Vanilla Swift | `swift/_base.md` |

### Mobile (Cross-platform)
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `app.json` / `app.config.ts` | `expo` | Expo | `mobile/react-native-expo.md` |
| `android/` + `ios/` dirs | `react-native` (no expo) | React Native | `mobile/react-native-expo.md` |
| `pubspec.yaml` + `lib/main.dart` | `flutter` SDK | Flutter | `mobile/flutter.md` |

### C / C++
| Signal | Dependency | Framework | Reference |
|---|---|---|---|
| `CMakeLists.txt` | — | CMake project | `cpp/cmake.md` |
| `Makefile` + `*.c`/`*.cpp` | — | Vanilla C/C++ | `cpp/_base.md` |

## Ambiguity Rules
- Multiple matches → prefer **most specific** (Next.js over React, SvelteKit over Svelte)
- Monorepo detected (workspaces, turborepo, nx) → detect each package separately
- Unknown framework → use language _base.md, note uncertainty
- Always verify by reading at least one source file — config files can be stale
- Astro vs Vite ambiguity: astro.config.* → Astro; vite.config.* without astro/remix/svelte → check for vue/react
