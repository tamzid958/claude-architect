---
allowed-tools: Bash(*), Edit(**)
---

Generate API endpoint(s) for: $ARGUMENTS

# API GENERATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Resource:** entity/model name (e.g., "users", "products", "orders")
- **Operations:** CRUD (default) | specific (e.g., "list + create only") | custom action
- **Auth:** required | optional | public
- **Relations:** belongs_to, has_many, nested routes

If $ARGUMENTS is vague ("add an API for posts"), ask:
```
1. Which operations? (full CRUD / specific subset / custom action)
2. Auth required? (JWT / session / API key / public)
3. Relations? (belongs to user? has many comments?)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md — check existing route patterns, naming conventions, middleware
2. Load matched framework reference file — check route structure, validation patterns
3. Read existing routes/controllers — match patterns exactly
4. Read existing models/schemas — understand data layer
5. Identify: validation library, error format, response shape, pagination pattern

**Output plan:**
```
## API Plan: [resource]

### Stack
Framework: [detected] | Validation: [lib] | ORM/Query: [lib]
Auth middleware: [existing pattern]
Response format: { data, error, meta } (from existing code)

### Endpoints
[METHOD] [path] — [description] — [auth]
[METHOD] [path] — [description] — [auth]
...

### Files to Create/Modify
- [route file] — endpoint definitions
- [controller/handler] — business logic
- [validation schema] — request validation
- [types/DTOs] — request/response types
- [test file] — endpoint tests
```

STOP and wait for approval.

## STEP 3: GENERATE

Per endpoint, create in order:
1. **Types/DTOs** — request body, response shape, query params
2. **Validation** — input validation schema (zod, pydantic, struct tags, etc.)
3. **Handler/Controller** — business logic with error handling
4. **Route registration** — wire into existing router
5. **Tests** — at minimum: happy path + validation error + not found + auth failure

### Framework Patterns

Follow detected framework's idioms:
- **Next.js App Router:** `app/api/[resource]/route.ts` with `GET/POST/PUT/DELETE` exports
- **Express/Hono:** router file with middleware chain
- **FastAPI:** router with Pydantic models, Depends() for auth
- **Django DRF:** ViewSet or APIView with serializers
- **Go (Chi/Gin/Echo):** handler functions with typed request structs
- **Rails:** controller with strong params, routes.rb entry
- **Spring Boot:** @RestController with @Valid DTOs
- **NestJS:** controller + service + DTO + module registration
- **Laravel:** controller + FormRequest + Route::apiResource

### Response Consistency
Match existing project patterns. If no pattern exists:
- Success: `{ data: T }` or `{ data: T[], meta: { total, page, limit } }`
- Error: `{ error: { code: string, message: string } }`
- Status codes: 200 (ok), 201 (created), 204 (deleted), 400 (validation), 401 (unauth), 404 (not found)

## STEP 4: VERIFY

1. Build passes — no type errors
2. Lint passes
3. Tests pass: `[test command]`
4. Manual smoke test if dev server available
5. Commit: `git add [files] && git commit -m "feat: add [resource] API endpoints"`

## STEP 5: OUTPUT SUMMARY

```
## API Generated: [resource]

### Endpoints
[METHOD] [path] — [status code examples]
...

### Files
- [file 1] — [what]
- [file 2] — [what]

### Auth
[auth pattern applied]

### Tests
[N] tests — [what they cover]

### Next Steps
- /test — expand coverage (edge cases, load)
- /doc — generate API reference
- /review — check for security issues
```

## API RULES
- **Match existing patterns** — if the project has a route style, follow it exactly
- **Validate all input** — never trust request data. Use the project's validation library
- **Type everything** — request bodies, response shapes, query params, path params
- **Error responses are API** — consistent error format matters as much as success format
- **Pagination by default** — list endpoints paginate. Match existing pattern or use cursor/offset
- **No business logic in routes** — routes validate + delegate. Logic lives in services/handlers
- **Test the contract** — test status codes, response shapes, error cases. Not implementation details
- **Idempotency matters** — PUT is idempotent, POST is not. DELETE returns 204 even if already gone
