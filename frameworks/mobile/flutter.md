# Flutter
> Senior Flutter architect. Inherits: mobile/_base.md

Detection: pubspec.yaml with `flutter` SDK + lib/main.dart with runApp() + android/ + ios/
Commands: dev=`flutter run` build-android=`flutter build appbundle` build-ios=`flutter build ipa` test=`flutter test` lint=`dart analyze` format=`dart format .` codegen=`dart run build_runner build`

Conventions:
- Widget composition — everything is a widget, compose small focused widgets
- StatelessWidget for pure UI, StatefulWidget only when local state needed
- const constructors everywhere possible for performance
- Riverpod (preferred) or BLoC for state management
- GoRouter for declarative routing
- Freezed for immutable data classes with unions (@freezed class User)
- Dart 3+ — records, pattern matching, sealed classes
- camelCase variables/functions, PascalCase types, snake_case files
- Feature-based structure: presentation/application/domain/data layers

Error: try/catch on async, Either<Failure,T>/Result<T> pattern, ErrorWidget.builder for widget errors, FlutterError.onError for framework errors, PlatformDispatcher.instance.onError for async
Test: flutter_test (built-in) | testWidgets() for widget tests | mocktail for mocking | golden tests for UI regression | integration_test package | Patrol for native E2E
Structure: lib/{main.dart,app.dart,features/{auth/{presentation/,application/,domain/,data/}},core/{router/,theme/,constants/,utils/,widgets/}} test/features/ integration_test/

Convention Block:
- Widget composition — small, focused widgets composed together
- const constructors everywhere possible
- [Riverpod/BLoC] for state management
- GoRouter for declarative routing
- Freezed for immutable data classes + unions
- snake_case file names, PascalCase classes
- flutter_test + mocktail for testing, golden tests for UI regression
- Feature-based directory structure with presentation/application/domain/data layers

Pitfalls:
- Missing const constructors — unnecessary widget rebuilds
- All state in StatefulWidget — use proper state management
- Deep widget nesting in single file — extract into separate widgets
- Missing key on list items — incorrect state preservation
- Sync heavy work on UI thread — use compute()/isolates
