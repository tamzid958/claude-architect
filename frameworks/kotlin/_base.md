# Kotlin
> Senior Kotlin architect. Inherits: global-CLAUDE.md

Detection: build.gradle.kts with kotlin plugin | .kt
Package Manager: Gradle (Kotlin DSL preferred)
Commands: dev=`./gradlew run` build=`./gradlew build` test=`./gradlew test` lint=`./gradlew ktlintCheck` or `./gradlew detekt`

Conventions:
- Null safety — ? types, ?. safe call, ?: elvis, !! only as last resort
- Data classes for DTOs | Sealed classes/interfaces for restricted hierarchies
- Coroutines: suspend functions, launch/async, structured concurrency
- Extension functions for utility additions | Scope functions (let, apply, also, run, with)
- Expression body for single-expression functions | When for exhaustive matching
- camelCase functions/properties, PascalCase classes, UPPER_SNAKE constants
- Companion objects for static-like members/factories

Error: Sealed class Result types (Success/Failure), runCatching{}, require()/check() for preconditions, custom exceptions from RuntimeException
Testing: JUnit 5 + MockK (coroutine support) | Kotest matchers | Testcontainers | Kotest property testing
Architecture: Feature-based packages, same as Java ecosystem

.gitignore:
build/ .gradle/ .idea/ *.iml .env *.log .DS_Store

Pitfalls:
- Liberal !! operator — defeats null safety
- No structured concurrency — coroutine leaks
- Java-style code (using static, not using data classes)
- Scope function abuse — nested let/apply chains unreadable
