# React Native & Expo
> Senior React Native/Expo architect. Inherits: mobile/_base.md

## React Native (Bare)
Detection: `react-native` in package.json (without `expo`) + android/ + ios/ native dirs + metro.config.js
Commands: dev-ios=`npx react-native run-ios` dev-android=`npx react-native run-android` start=`npx react-native start` test=`npx jest` lint=`npx eslint .` pods=`cd ios && pod install`

Conventions:
- Functional components + hooks — no class components
- Platform-specific files — Component.ios.tsx / Component.android.tsx
- React Navigation — @react-navigation/native for screen management
- Native modules bridge to iOS/Android APIs via NativeModules
- New Architecture (Fabric + TurboModules) for new projects
- Hermes engine enabled by default
- StyleSheet.create for styling — not inline objects
- FlatList over ScrollView for all dynamic lists (virtualized)

Error: ErrorBoundary for render errors, ErrorUtils.setGlobalHandler() for global, try/catch in async
Pitfalls:
- Inline style objects (new objects every render) — use StyleSheet.create
- ScrollView for long lists — use FlatList
- Forgetting pod install after adding native deps (iOS)
- Not handling Android back button with navigation

## Expo
Detection: `expo` in package.json + app.json/app.config.ts + app/_layout.tsx (Router)
Commands: dev=`npx expo start` build=`eas build --platform [ios/android]` test=`npx jest` prebuild=`npx expo prebuild` update=`eas update`

Conventions:
- Expo Router — file-based routing in app/ directory (like Next.js for mobile)
- _layout.tsx for navigation structure (Stack, Tabs, Drawer)
- Expo modules over community packages when available (expo-image, expo-camera)
- EAS Build for cloud builds, EAS Update for OTA updates
- Config plugins for native configuration without ejecting
- app.config.ts for dynamic typed configuration
- Development builds for native module testing

Error: ErrorBoundary export per route (Expo Router), ErrorUtils global, expo-updates fallback
Pitfalls:
- Bare RN packages when Expo equivalents exist — less reliable
- Not using Expo Router — loses file-based benefits
- expo eject — use expo prebuild + config plugins instead
- Large app.json — use app.config.ts for dynamic config

## Shared
State: TanStack Query (server) | Zustand/Jotai (client) | MMKV (persistent storage) | React Context (auth/theme)
Test: Jest + React Native Testing Library | E2E: Detox (bare RN) / Maestro (Expo) | snapshot for UI regression
Structure: src/{screens/,components/{ui/,shared/},navigation/,hooks/,services/,stores/,types/,utils/}

Convention Block (React Native):
- Functional components + hooks — no class components
- React Navigation for screen management
- Platform-specific: .ios.tsx / .android.tsx when needed
- FlatList for all lists — never ScrollView for dynamic data
- StyleSheet.create for styling — not inline objects
- RNTL for component testing, Detox for E2E
- MMKV for persistent storage, TanStack Query for server state

Convention Block (Expo):
- Expo Router for file-based navigation — app/ directory
- _layout.tsx for navigation structure (Stack, Tabs, Drawer)
- Expo modules over community packages when available
- EAS Build for cloud builds, EAS Update for OTA
- app.config.ts for typed configuration
- expo-image over Image for better performance
- RNTL for component testing, Maestro for E2E
