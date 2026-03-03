# Spring Boot
> Senior Spring Boot architect. Inherits: java/_base.md

Detection: spring-boot-starter in pom.xml/build.gradle + @SpringBootApplication class + application.yml
Commands: dev=`./mvnw spring-boot:run` or `./gradlew bootRun` docker=`./mvnw spring-boot:build-image`

Conventions:
- Controller → Service → Repository layered architecture
- Constructor injection always — never field @Autowired, use @RequiredArgsConstructor
- @RestController with @GetMapping/@PostMapping, @Validated for Bean Validation on DTOs
- Spring Data JPA: JpaRepository<Entity,ID>, derived queries, @Transactional on services
- Profiles: application-{dev,prod}.yml for environment config
- Spring Security: SecurityFilterChain bean, [Authorize] endpoints
- @ControllerAdvice + @ExceptionHandler for global errors — ProblemDetail (RFC 7807)
- Flyway/Liquibase for DB migrations

Error: @ControllerAdvice global handler, ProblemDetail responses, custom exception hierarchy
Test: @WebMvcTest (controller slice) | @DataJpaTest (repo slice) | @SpringBootTest + Testcontainers (full) | MockMvc for HTTP
Structure: src/main/java/com/app/{feature}/{Controller,Service,Repository,Entity,dto/,mapper/} src/test/

Convention Block:
- Controller → Service → Repository layers
- Constructor injection — never field @Autowired
- Records for DTOs + Bean Validation, Spring Data JPA
- @ControllerAdvice — ProblemDetail error responses
- @WebMvcTest for controllers, Testcontainers for integration
- Flyway for migrations, Profiles for env config

Pitfalls:
- Field injection — untestable, use constructor
- Missing @Transactional — no transaction boundary
- N+1 with JPA — use @EntityGraph or JOIN FETCH
- Full @SpringBootTest when slice test suffices — slow
- Business logic in controllers
