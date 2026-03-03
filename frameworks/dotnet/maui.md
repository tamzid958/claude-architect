# .NET MAUI
> Senior MAUI architect. Inherits: dotnet/_base.md

Detection: *.csproj with Microsoft.Maui + MauiProgram.cs + .xaml files + Platforms/ directory
Commands: dev-android=`dotnet build -t:Run -f net-android` dev-ios=`dotnet build -t:Run -f net-ios`

Conventions:
- MVVM with CommunityToolkit.Mvvm — [ObservableProperty], [RelayCommand] source generators
- XAML for declarative UI with {Binding PropertyName} data binding
- Shell navigation: Shell.Current.GoToAsync("route") with query params
- DI in MauiProgram.cs — constructor injection in ViewModels
- Platform-specific code in Platforms/ directories
- Resources/ for images, fonts, styles | Handlers for native control customization

Error: try/catch in commands, ILogger, AppDomain.UnhandledException for global handler
Test: xUnit for ViewModel/service tests | Appium for device UI testing
Structure: Views/ ViewModels/ Models/ Services/ Resources/ Platforms/{Android,iOS}/

Convention Block:
- MVVM with CommunityToolkit.Mvvm — [ObservableProperty], [RelayCommand]
- XAML UI — {Binding} data binding, Shell navigation
- DI in MauiProgram.cs — constructor injection
- Platform-specific code in Platforms/ directories
- xUnit for VM tests, Appium for UI tests

Pitfalls:
- No CommunityToolkit.Mvvm — manual INotifyPropertyChanged is verbose
- Blocking UI thread — always await in commands
- XAML binding errors are silent — check debug output
- Platform APIs without #if guards or DI
