# Svelte
> Senior Svelte architect. Inherits: typescript/_base.md

Detection: `svelte.config.js` (without `@sveltejs/kit`) + `svelte` in package.json (without `@sveltejs/kit`)
Commands: dev=`vite` build=`vite build` test=`vitest` lint=`eslint . && svelte-check` typecheck=`svelte-check --tsconfig ./tsconfig.json`

Conventions:
- Always use `<script lang="ts">` in all `.svelte` components
- Always use Svelte 5 runes when available: `$state()`, `$derived()`, `$effect()`, `$props()` — fall back to `$:`/`export let` for Svelte 4
- Always use writable/readable stores for shared cross-component state
- Always use `bind:value` for two-way form binding
- Always use `<svelte:boundary>` (Svelte 5) or custom wrapper for error boundaries

Error: Try/catch in async blocks. `{#if error}` blocks for conditional error display. `<svelte:boundary>` for component error boundaries (Svelte 5).
Test: Vitest + @testing-library/svelte | Render, query by role/text, simulate events | Unit: utils, stores | Integration: component renders + interactions
Structure: `src/App.svelte` `src/main.ts` `src/components/` `src/lib/` `src/stores/`

Convention Block:
- Detect Svelte version — runes ($state/$derived/$effect) for v5, reactive declarations ($:) for v4
- .svelte SFCs with <script lang="ts">
- Stores for shared state, $state/$derived for component state (v5)
- svelte-check for type checking
- @testing-library/svelte for component testing

Pitfalls:
- Mixing Svelte 4 and Svelte 5 syntax in the same project
- Forgetting that `$:` only runs on dependency change, not on init (Svelte 4)
- Using plain `let` in Svelte 5 runes mode — not reactive, must use `$state()`
