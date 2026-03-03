# SwiftUI
> Senior SwiftUI architect. Inherits: swift/_base.md

Detection: *.xcodeproj/*.xcworkspace with `import SwiftUI` + ContentView.swift + @main struct App
Commands: build=`xcodebuild -scheme [Scheme] -destination 'platform=iOS Simulator,name=iPhone'` test=`xcodebuild test -scheme [Scheme]` lint=`swiftlint`

Conventions:
- Declarative UI — compose views with VStack, HStack, ZStack, List
- MVVM — View (SwiftUI) + ViewModel (@Observable) + Model
- @State for local, @Binding for parent-child, @StateObject for view-owned observable
- @EnvironmentObject for deep injection without prop drilling
- @Observable macro (latest) — replaces ObservableObject + @Published
- NavigationStack + .navigationDestination (not deprecated NavigationView)
- Modifiers chained: .padding().font().foregroundColor()
- #Preview { } for live Xcode previews
- task {} modifier for async data loading on view appear
- Extract sub-views early — keep body simple

Error: .alert()/.sheet() for error presentation, Result<T,E> in ViewModels, error state enum in VM
Test: XCTest for ViewModel unit tests | ViewInspector for view testing | swift-snapshot-testing for UI regression | XCUITest for E2E
Structure: App/{[AppName]App.swift,ContentView.swift} Features/{Auth/{AuthView,AuthViewModel},Users/} Components/ Models/ Services/ Extensions/ Resources/ Tests/

Convention Block:
- MVVM: View (SwiftUI) + ViewModel (@Observable) + Model
- @State for local, @Binding for parent-child, @EnvironmentObject for deep injection
- NavigationStack for navigation (not NavigationView)
- Extract views early — keep body simple and readable
- task {} modifier for async data loading
- XCTest for ViewModel tests, XCUITest for E2E

Pitfalls:
- @ObservedObject when @StateObject needed (object recreated on re-render)
- Complex body — extract sub-views for readability and performance
- NavigationView instead of NavigationStack (deprecated)
- onAppear + Task {} instead of task {} modifier
- State mutation off main actor — use @MainActor on ViewModels
