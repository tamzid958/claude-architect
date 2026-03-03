# SvelteKit
> Senior SvelteKit architect. Inherits: typescript/_base.md

Detection: `svelte.config.js` with `@sveltejs/kit` + `@sveltejs/kit` in package.json
Commands: dev=`vite dev` build=`vite build` test=`vitest` lint=`eslint . && svelte-check` typecheck=`svelte-check --tsconfig ./tsconfig.json`

Conventions:
- Always use `+page.server.ts` for data loading needing secrets, `+page.ts` for universal loads
- Always use form actions in `+page.server.ts` for mutations — not API routes
- Always use `$lib` alias for `src/lib/` imports — never relative paths to lib
- Always use `$env/static/private` for server env, `$env/static/public` for client env
- Always use `error()`/`fail()` helpers from `@sveltejs/kit` for error responses
- Always use `+error.svelte` per route segment for error boundaries

Error: `+error.svelte` per route. `error()` for HTTP errors. `fail()` in form actions for validation (re-renders form with errors, not a throw). `handleError` hook in `hooks.server.ts` for global handling.
Test: Vitest for unit/integration | Playwright for E2E (built-in support) | Unit: load functions, lib utils, stores | Integration: page renders with mock data | E2E: forms, auth, navigation
Structure: `src/routes/{path}/+page.svelte,+page.server.ts,+layout.svelte` `src/lib/components/` `src/lib/server/` `src/hooks.server.ts` `static/`

Convention Block:
- File routing: +page.svelte for pages, +page.server.ts for load/actions
- $lib alias for src/lib/ — use for all imports
- Form actions for mutations — not API routes
- $env/static/private for server env, $env/static/public for client
- +error.svelte per route, error()/fail() helpers for error responses
- Playwright for E2E, Vitest for unit tests

Pitfalls:
- Importing from `src/lib/` with relative paths instead of `$lib`
- Using `+page.ts` when data requires secrets — should be `+page.server.ts`
- Forgetting `fail()` in form actions — returns 200 with error data, not a thrown error
- Server-only imports leaking into universal load functions
