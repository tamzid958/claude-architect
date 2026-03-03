# Mobile (JS/TS Cross-Platform)
> Senior mobile architect. Inherits: typescript/_base.md

Detection: react-native or expo in package.json + android/ or ios/ directories
Package Manager: See typescript/_base.md
Commands: test=`jest` lint=`eslint .`

Conventions:
- Platform-specific files when needed: .ios.tsx / .android.tsx
- TanStack Query for server state, Zustand for client state
- MMKV for fast local storage over AsyncStorage
- Avoid large imports — tree-shake carefully for bundle size

Error: ErrorBoundary for component errors, ErrorUtils for global handler, try/catch on async
Testing: Jest + React Native Testing Library | E2E: Maestro or Detox

.gitignore:
*.jks *.p8 *.p12 *.key *.mobileprovision *.orig.* .env *.log .DS_Store

Pitfalls:
- Large bundle from importing full libraries — use specific imports
- Blocking JS thread with heavy sync operations — use native modules or workers
