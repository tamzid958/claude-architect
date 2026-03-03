# Remix
> Senior Remix architect. Inherits: typescript/_base.md

Detection: `vite.config.ts` with `@remix-run/dev` + `@remix-run/node`/`@remix-run/react` in package.json
Commands: dev=`remix vite:dev` build=`remix vite:build` test=`vitest` lint=`eslint .` typecheck=`tsc --noEmit`

Conventions:
- Always use `loader` for GET data and `action` for mutations — both are server-only
- Always use `<Form>` component for progressive enhancement — forms work without JS
- Always use `useFetcher` for non-navigation mutations (like/unlike, inline updates)
- Always use `.server.ts` suffix for server-only modules — prevents client bundle leaks
- Always use Web Standard APIs (Request/Response/FormData) — never Express req/res patterns
- Always use dot-delimited file routing: `users.$id.tsx`

Error: `export function ErrorBoundary()` per route catches loader, action, and render errors. Return `json({ errors }, { status: 400 })` from actions. Throw `new Response("Not Found", { status: 404 })` in loaders. `isRouteErrorResponse()` to distinguish HTTP vs unexpected errors.
Test: Vitest + React Testing Library | `createRemixStub` for route testing | Unit: loader/action logic, validators | Integration: route components via createRemixStub | E2E: Playwright
Structure: `app/root.tsx` `app/routes/_index.tsx,users.$id.tsx,api.users.ts` `app/components/` `app/lib/{name}.server.ts` `app/styles/`

Convention Block:
- Loaders for GET data, Actions for mutations — both server-only
- File routing with dot-delimited nesting: users.$id.tsx
- <Form> for progressive enhancement — works without JS
- useFetcher for non-navigation mutations
- .server.ts suffix for server-only modules
- Web standard Request/Response — not Express
- ErrorBoundary export per route for error handling

Pitfalls:
- Importing server-only code without `.server.ts` suffix — bundles secrets into client
- Using `useEffect` for data fetching instead of loaders
- Not using `<Form>` or `useFetcher` — breaks progressive enhancement
- Throwing errors in actions instead of returning them — breaks error UX
- Using Express req/res patterns instead of Web Standard Request/Response
