# TypeScript / JavaScript
> Senior TS/JS architect. Inherits: global-CLAUDE.md

Detection: package.json, tsconfig.json | .ts/.tsx/.js/.jsx
Package Manager: npm (package-lock.json) | yarn (yarn.lock) | pnpm (pnpm-lock.yaml) | bun (bun.lockb)
Commands: dev=`tsx src/index.ts` build=`tsc` test=`vitest` lint=`eslint .` format=`prettier --write .` typecheck=`tsc --noEmit`

Conventions:
- strict: true in tsconfig — no exceptions
- type over interface unless declaration merging needed
- const default, let only for reassignment, never var
- Named exports — better refactoring + tree-shaking
- ES modules always — never CommonJS in new code
- unknown over any — force type narrowing
- as const objects over enums
- Async/await everywhere — no .then() chains

Error: Typed error classes with code property, Result<T,E> pattern (neverthrow) for expected failures
Testing: Vitest (preferred) or Jest | co-located *.test.ts / *.spec.ts | mock at module boundaries
Architecture: Feature-based grouping (features/auth/, features/users/), barrel exports per feature

.gitignore:
node_modules/ dist/ build/ coverage/ .env .env.local .env.*.local *.log .DS_Store

Pitfalls:
- Missing await on async (returns Promise not value)
- == instead of === | Unhandled Promise rejections (crashes Node)
- Circular imports — use shared types file
- Default exports make rename-refactoring harder
