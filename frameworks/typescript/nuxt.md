# Nuxt
> Senior Nuxt architect. Inherits: typescript/_base.md

Detection: `nuxt.config.{ts,js}` + `nuxt` in package.json
Commands: dev=`nuxi dev` build=`nuxi build` test=`vitest` lint=`eslint .` typecheck=`nuxi typecheck` generate=`nuxi generate`

Conventions:
- Always rely on auto-imports — components, composables, and utils are auto-imported, never add manual imports for them
- Always use `useFetch()`/`useAsyncData()`/`$fetch()` for data fetching — never raw `fetch`
- Always use `useRuntimeConfig()` for env vars — never `process.env` directly
- Always use `useState()` for SSR-safe shared state, Pinia for complex stores
- Always use server routes in `server/api/` with method suffixes (`users.get.ts`, `users.post.ts`)
- Always use `useHead()` for SEO metadata

Error: `error.vue` at root for global error page. `createError({ statusCode, message })` for typed errors. `showError()`/`clearError()` for programmatic handling. Server routes throw `createError()`.
Test: Vitest + @nuxt/test-utils | `mountSuspended()` for async components | `mockNuxtImport()` for auto-imports | Unit: composables, server utils | Integration: pages, API routes | E2E: Playwright
Structure: `pages/{route}.vue` `components/` `composables/` `server/api/` `server/middleware/` `layouts/` `middleware/` `plugins/` `public/`

Convention Block:
- Auto-imports for components, composables, and utils — don't add manual imports
- File-based routing in pages/ — [param].vue for dynamic segments
- Server routes in server/api/ — method suffix: users.get.ts, users.post.ts
- useFetch/useAsyncData for data fetching — never raw fetch
- useRuntimeConfig() for env vars — never process.env
- useState() for SSR-safe state, Pinia for complex stores

Pitfalls:
- Manually importing composables/components that are auto-imported
- Using `process.env` instead of `useRuntimeConfig()`
- Using `ref()` for SSR-shared state instead of `useState()`
- Raw `fetch` instead of `useFetch`/`$fetch` — misses Nuxt's serialization/caching
- Server-side code leaking into client bundle — keep it in `server/`
