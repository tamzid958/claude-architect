# React (SPA / Vite)
> Senior React architect. Inherits: typescript/_base.md

Detection: `vite.config.ts` with `@vitejs/plugin-react` + `react`+`react-dom` in package.json (without next/remix)
Commands: dev=`vite` build=`vite build` test=`vitest` lint=`eslint .` typecheck=`tsc --noEmit`

Conventions:
- Always use functional components + hooks — never class components in new code
- Always use PascalCase files, one component per file, co-locate tests/styles
- Always extract reusable logic into `use*` custom hooks
- Always use TanStack Query for server state, Zustand/Context for UI state
- Always use stable unique keys in lists — never array index
- Always use `React.memo`/`useMemo`/`useCallback` only when measurably needed

Error: ErrorBoundary component at route level for render errors. Try/catch in async ops. User-facing error states in every data-loading component.
Test: Vitest + React Testing Library | MSW for API mocking — never mock fetch directly | Unit: hooks, utils | Integration: component renders + interactions | E2E: Playwright
Structure: `src/main.tsx` `src/App.tsx` `src/features/{name}/` `src/components/ui/` `src/hooks/` `src/lib/` `src/types/`

Convention Block:
- Functional components + hooks only — no class components
- PascalCase component files, one component per file
- Custom hooks in hooks/ or co-located with feature
- TanStack Query for server state, Zustand/Context for UI state
- React Testing Library — test behavior, not implementation
- ErrorBoundary at route level for render errors

Pitfalls:
- Missing dependency array in `useEffect` causing infinite loops
- Creating objects/arrays in render without memoization — breaks `React.memo`
- Using index as key in dynamic lists — causes stale/wrong renders
- Mutating state directly instead of creating new references
- Overusing `useEffect` — derive state from existing state, don't sync
