# Blazor
> Senior Blazor architect. Inherits: dotnet/_base.md

Detection: *.csproj with Microsoft.AspNetCore.Components + .razor files + _Imports.razor
Commands: dev=`dotnet watch run`

Conventions:
- Render modes: InteractiveServer, InteractiveWebAssembly, InteractiveAuto — choose per component
- .razor components with @code{} blocks, PascalCase naming
- [Parameter] for props, EventCallback<T> for parent notification
- <EditForm> with DataAnnotationsValidator for forms
- @inject for DI | Cascading values for deeply shared state
- Lifecycle: OnInitializedAsync, OnParametersSetAsync, OnAfterRenderAsync
- JS interop via IJSRuntime only when unavoidable

Error: <ErrorBoundary> at layout level, try/catch in lifecycle, ILogger for reporting
Test: bUnit for component testing (render, assert markup, trigger events) | Playwright for E2E
Structure: Components/{Pages/,Layout/,Shared/} Services/ Models/ wwwroot/

Convention Block:
- Render mode: [Server/WASM/Auto] per component
- .razor components — [Parameter] for props, EventCallback<T> for events
- <EditForm> with DataAnnotationsValidator for forms
- @inject for DI, <ErrorBoundary> for error recovery
- bUnit for component testing

Pitfalls:
- Wrong render mode (Server needs SignalR, WASM needs download)
- Excessive StateHasChanged() — triggers unnecessary re-renders
- JS interop during prerendering — JS not available in SSR
- Blocking async in lifecycle — always await
