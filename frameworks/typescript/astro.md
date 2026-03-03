# Astro
> Senior Astro architect. Inherits: typescript/_base.md

Detection: `astro.config.{mjs,ts}` + `astro` in package.json
Commands: dev=`astro dev` build=`astro build` test=`vitest` lint=`eslint .` typecheck=`astro check` preview=`astro preview`

Conventions:
- Always ship zero JS by default — only add `client:*` directives for interactive islands
- Always use `.astro` for static components, `.tsx/.vue/.svelte` for interactive islands
- Always use Content Collections in `src/content/` with typed schemas for structured content
- Always use `astro:assets` Image component for optimized images
- Always use `client:idle` or `client:visible` for deferred hydration — reserve `client:load` for critical interactivity

Error: `src/pages/404.astro` and `src/pages/500.astro` for error pages. API endpoints return `Response` objects with status codes. Content collection schemas catch errors at build time.
Test: Vitest for unit | Playwright for E2E | Unit: utils, content schemas, API endpoints | E2E: page renders, navigation | Snapshot: static page output
Structure: `src/pages/{route}.astro` `src/pages/api/{endpoint}.ts` `src/content/config.ts,{collection}/` `src/components/` `src/layouts/` `public/`

Convention Block:
- Zero JS by default — use client:* directives only for interactive islands
- .astro for static, .tsx/.vue/.svelte for interactive components
- Content Collections in src/content/ with typed schemas
- File routing in src/pages/ — .astro for pages, .ts for API endpoints
- astro:assets Image component for optimized images
- client:load for critical interactivity, client:idle/visible for deferred

Pitfalls:
- Adding `client:load` to everything — defeats Astro's zero-JS purpose
- Using React hooks in `.astro` files — only works in `.tsx` islands
- Forgetting `client:*` directive on interactive components — renders static HTML only
- Not using Content Collections for structured content — loses type safety
