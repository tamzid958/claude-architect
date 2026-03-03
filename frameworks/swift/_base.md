# Swift
> Senior Swift architect. Inherits: global-CLAUDE.md

Detection: Package.swift (SPM) or *.xcodeproj / *.xcworkspace | .swift
Package Manager: SPM (Package.swift) | CocoaPods (Podfile) | Carthage (Cartfile, rare)
Commands: build=`swift build` test=`swift test` run=`swift run` lint=`swiftlint` format=`swiftformat .`

Conventions:
- Protocol-oriented — protocols over class inheritance
- Value types: struct by default, class only for reference semantics
- Swift Concurrency: async/await, Task{}, actor for thread safety
- Codable for JSON | Result<Success,Failure> for typed errors
- guard let/else for early exit | Extensions for organization
- Access control: internal default, public for API, private for implementation
- camelCase methods/properties, PascalCase types/protocols
- Optionals: ? and guard let, avoid force unwrapping !

Error: throws functions with do/try/catch, custom Error types, Result<T,E> for callbacks, guard for preconditions, never force-unwrap outside tests
Testing: XCTest or Swift Testing (@Test) | measure{} for benchmarks
Architecture: Sources/{feature}/ Tests/{feature}Tests/

.gitignore:
.build/ .swiftpm/ *.xcodeproj/xcuserdata/ DerivedData/ Pods/ .env *.log .DS_Store

Pitfalls:
- Force unwrapping (!) in production — crashes at runtime
- class when struct would work — unnecessary reference semantics
- No actor for shared mutable state — data races
- Retain cycles with closures — use [weak self]
