# Vue.js
> Senior Vue.js architect. Inherits: typescript/_base.md

Detection: `vite.config.ts` with `@vitejs/plugin-vue` + `vue` in package.json (without `nuxt`)
Commands: dev=`vite` build=`vite build` test=`vitest` lint=`eslint .` typecheck=`vue-tsc --noEmit`

Conventions:
- Always use Composition API with `<script setup lang="ts">` — never Options API
- Always use `defineProps<T>()`/`defineEmits<T>()` with TypeScript generics
- Always use `ref()` for state (prefer over `reactive()`), `computed()` for derived values
- Always use Pinia with setup syntax for state management — never Vuex
- Always extract reusable logic into `use*` composables
- Always use `defineModel()` for two-way binding

Error: `onErrorCaptured` for component tree errors, `app.config.errorHandler` for global. `<Suspense>` with fallback for async components.
Test: Vitest + Vue Test Utils | `mount()`/`shallowMount()` | Mock Pinia with `createTestingPinia()` | Unit: composables, store actions | Integration: component + store + router | E2E: Playwright
Structure: `src/App.vue` `src/views/` `src/components/ui/` `src/composables/` `src/stores/` `src/router/` `src/lib/` `src/types/`

Convention Block:
- Composition API with <script setup lang="ts"> — no Options API
- PascalCase .vue files, defineProps/defineEmits with TypeScript generics
- Pinia for state management (setup syntax stores)
- Composables (use* functions) for reusable logic
- Vue Router for routing, views/ for page components
- Vitest + Vue Test Utils for testing

Pitfalls:
- Destructuring reactive objects — loses reactivity, use `toRefs()`
- Forgetting `.value` when reading refs in `<script>` (not needed in `<template>`)
- Using Vuex instead of Pinia in new projects
- Not using `<script setup>` — it's shorter, faster, and better typed
- Using Options API in new code when Composition API is available
