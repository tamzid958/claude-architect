# Quarkus
> Senior Quarkus architect. Inherits: java/_base.md

Detection: io.quarkus in pom.xml/build.gradle + application.properties + @Path resources or @QuarkusMain
Commands: dev=`./mvnw quarkus:dev` (live reload + Dev Services) native=`./mvnw package -Dnative`

Conventions:
- CDI: @ApplicationScoped, @RequestScoped, @Inject for DI
- RESTEasy Reactive: @Path, @GET, @POST for endpoints
- Panache: PanacheEntity (Active Record) or PanacheRepository for ORM
- Dev Services: auto-starts DB, Kafka in dev mode — zero config
- Config: @ConfigProperty, profiles via %dev./%prod. prefix
- Reactive: Uni<T>, Multi<T> for Mutiny reactive streams
- Design for GraalVM native — avoid reflection, use @RegisterForReflection
- Use Quarkus extensions over generic libraries (build-time optimization)

Error: ExceptionMapper<T> or @ServerExceptionMapper for global HTTP errors, @Valid + Bean Validation
Test: @QuarkusTest + REST-assured (built-in) | @QuarkusIntegrationTest for native | @InjectMock
Structure: src/main/java/com/app/{feature}/{Resource,Service,Repository,Entity} src/main/resources/application.properties

Convention Block:
- CDI for DI — @ApplicationScoped, @Inject
- RESTEasy Reactive endpoints — @Path, @GET, @POST
- Panache ORM — Active Record or Repository pattern
- Dev Services for zero-config dev databases
- %dev./%prod. config profiles
- @QuarkusTest + REST-assured for testing

Pitfalls:
- Reflection-heavy libraries — breaks native compilation
- Not using Quarkus extensions — misses build-time optimization
- Blocking reactive endpoints — use Uni<T> or @Blocking
- Missing @RegisterForReflection for DTOs in native builds
