# TypeScript API Frameworks
> Senior TS API architect. Inherits: typescript/_base.md

## Express
Detection: `express` in package.json
Commands: dev=`npx tsx watch src/index.ts` start=`node dist/index.js`
Conventions:
- Router per resource: routes/users.ts, routes/auth.ts
- Middleware chain: app.use() global, router.use() scoped
- Async handler wrapper on all async routes — catch rejected promises
- Zod/Joi validation on every endpoint input
- Consistent response envelope: { success, data, error, meta }
- Global error handler as last middleware (err, req, res, next) — 4 params required
Error: Custom AppError with statusCode, asyncHandler wrapper propagates to error middleware
Pitfalls:
- Missing next(err) in async handlers — request hangs forever
- Error handler without 4 params — Express won't recognize it
- No request validation — trusting req.body directly
- res.send() after res.json() — headers already sent

## Hono
Detection: `hono` in package.json
Commands: dev=`npm run dev` or `wrangler dev` (Cloudflare) or `bun run src/index.ts`
Conventions:
- Multi-runtime: Cloudflare Workers, Bun, Deno, Node.js, Lambda
- @hono/zod-validator for type-safe request validation
- c.json(), c.text(), c.html() for responses — never raw Response
- Route groups: app.route('/api/users', usersApp)
- RPC mode: hc<AppType>() for type-safe client-server
- Web Standard Request/Response APIs
Error: HTTPException for typed errors, app.onError() + app.notFound() global handlers
Pitfalls:
- Using Node.js APIs on edge runtimes (no fs, path)
- Cloudflare env var access via c.env, not process.env
- Not using zod-validator — manual parsing is error-prone

## Shared
Test: Vitest + supertest (Express) / app.request() (Hono) | Unit: validators, middleware | Integration: full request cycle
Structure: src/{index,app,routes/,controllers/,middleware/,services/,validators/,types/}.ts

Convention Block (Express):
- Router per resource in routes/ — controller logic in controllers/
- Global error handler as last middleware — AppError class with statusCode
- Async handler wrapper on all async routes
- Zod validation on every endpoint input
- Consistent response: { success, data, error }

Convention Block (Hono):
- Web Standard Request/Response — runs on any runtime
- Route groups via app.route() — modular sub-apps
- @hono/zod-validator for typed request validation
- c.json/c.text for responses — HTTPException for errors
- Test routes with app.request() — no server needed
