# Java
> Senior Java architect. Inherits: global-CLAUDE.md

Detection: pom.xml (Maven) or build.gradle / build.gradle.kts (Gradle) | .java
Package Manager: Maven (pom.xml + mvnw) | Gradle (build.gradle + gradlew)
Commands: dev=`./mvnw spring-boot:run` or `./gradlew run` build=`./mvnw package` or `./gradlew build` test=`./mvnw test` or `./gradlew test` lint=`./mvnw checkstyle:check`

Conventions:
- Latest stable Java — records, sealed classes, pattern matching, text blocks, switch expressions
- Records for immutable DTOs | var for obvious local types
- Optional for return types — never for params or fields, never return null
- Streams: .stream().filter().map().collect() over manual loops
- PascalCase classes, camelCase methods/variables, UPPER_SNAKE constants
- Package-by-feature: com.app.users, com.app.auth (not by layer)
- Interfaces for contracts | final fields, unmodifiable collections, immutability
- @Override, @NonNull, @Deprecated consistently

Error: Custom exceptions from RuntimeException, specific types, never catch Exception/Throwable broadly, global handler at framework level
Testing: JUnit 5 + AssertJ + Mockito | Testcontainers for real DB | ArchUnit for dependency rules | JMH for benchmarks
Architecture: src/main/java/com/app/{feature}/{Model,Service,Repository,Controller} | src/test/

.gitignore:
target/ build/ .gradle/ .idea/ *.iml .settings/ .classpath .project .env *.log .DS_Store

Pitfalls:
- Returning null instead of Optional
- Catching Exception broadly — masks real bugs
- Mutable DTOs — use records or final fields
- Business logic in controllers instead of service layer
