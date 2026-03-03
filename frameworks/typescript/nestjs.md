# NestJS
> Senior NestJS architect. Inherits: typescript/_base.md

Detection: `nest-cli.json` + `@nestjs/core` in package.json | Entry: `src/main.ts` with `NestFactory.create()`
Commands: dev=`nest start --watch` build=`nest build` test=`jest` test:e2e=`jest --config jest-e2e.json` lint=`eslint .`

Conventions:
- Always organize as one module per feature — `@Module` groups controller + service + DTOs
- Always use constructor-based dependency injection — Nest IoC manages lifecycle
- Always use `class-validator` DTOs with global `ValidationPipe` on every input
- Always use `HttpException` subclasses for errors — never raw `Error`
- Always use Guards for auth, Interceptors for cross-cutting concerns, Pipes for validation
- Always decorate injectable classes with `@Injectable()`

Error: Throw `HttpException` subclasses (`NotFoundException`, `BadRequestException`). Custom exception filters with `@Catch()`. `ValidationPipe` auto-returns 400 with field errors.
Test: Jest + @nestjs/testing | `Test.createTestingModule()` for DI | Mock providers with `useValue`/`useFactory` | Unit: services, pipes, guards | Integration: controllers via supertest | E2E: full app bootstrap + supertest
Structure: `src/app.module.ts` `src/{feature}/{feature}.module.ts,.controller.ts,.service.ts,dto/,entities/` `src/common/filters,interceptors,pipes,decorators/` `test/`

Convention Block:
- Module per feature — controller + service + DTOs grouped together
- Constructor DI — inject services via constructor params
- class-validator DTOs on all inputs — ValidationPipe globally enabled
- HttpException subclasses for errors — never raw Error
- Guards for auth, Interceptors for cross-cutting, Pipes for validation
- Jest + @nestjs/testing for unit/integration tests

Pitfalls:
- Forgetting to import a module in `imports` array — DI fails silently
- Not enabling `ValidationPipe` globally — DTOs are ignored
- Circular dependencies between modules — use `forwardRef()`
- Using `@Inject()` without token for non-class providers
- Not decorating injectable classes with `@Injectable()`
