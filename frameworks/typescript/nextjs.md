# Next.js
> Senior Next.js architect. Inherits: typescript/_base.md

Detection: `next.config.{js,mjs,ts}` + `next` in package.json | `app/` (App Router) or `pages/` (Pages Router)
Commands: dev=`next dev` build=`next build` test=`vitest` lint=`next lint` typecheck=`tsc --noEmit`

Conventions:
- Always use Server Components by default — only add `'use client'` for browser APIs, hooks, or event handlers
- Always use `next/image`, `next/font`, `next/link` — never raw `<img>`, external font `<link>`, or `<a>` for internal nav
- Always use Server Actions (`'use server'`) for mutations over API routes
- Always export `metadata` object or `generateMetadata()` — never `<Head>`
- Always prefix client-exposed env vars with `NEXT_PUBLIC_`
- Always use `useRouter` from `next/navigation` — never `next/router` in App Router

Error: `error.tsx` (must be `'use client'`) per route segment, `global-error.tsx` at root, `not-found.tsx` for 404. Server Actions return `{ error }` — don't throw. Route handlers return `NextResponse.json({ error }, { status })`.
Test: Vitest/Jest + @testing-library/react | Mock `next/navigation`, `next/image` | Unit: server actions, utils | Integration: API routes, page renders | E2E: Playwright
Structure: `app/{feature}/page.tsx,layout.tsx,loading.tsx,error.tsx,actions.ts` `app/api/{resource}/route.ts` `components/ui/` `lib/` `types/`

Convention Block:
- Server Components by default — only 'use client' for interactivity
- File routing in app/ — page.tsx, layout.tsx, loading.tsx, error.tsx
- Server Actions for mutations — 'use server' functions, not API routes
- next/image for all images, next/font for fonts, next/link for navigation
- NEXT_PUBLIC_ prefix for client-exposed env vars
- Metadata via export const metadata, not Head

Pitfalls:
- Importing `useRouter` from `next/router` instead of `next/navigation` in App Router
- Adding `'use client'` to every component — defeats Server Components purpose
- Fetching data in client components instead of server components or server actions
- Forgetting `error.tsx` must be a client component
- Mixing `pages/` and `app/` routing outside migration mode
