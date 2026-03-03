# Tauri
> Senior Tauri desktop architect. Inherits: rust/_base.md

Detection: src-tauri/ + tauri in Cargo.toml + tauri.conf.json
Commands: dev=`cargo tauri dev` build=`cargo tauri build` test=`cargo test` (Rust) + `npm test` (frontend)

Conventions:
- #[tauri::command] for IPC functions callable from frontend JS
- Event system: emit()/listen() for async frontend-backend communication
- Security: scoped permissions in tauri.conf.json — minimal allowlist
- tauri::State<T> for shared Rust state
- Frontend agnostic — React, Vue, Svelte, or any web framework
- Plugin system for extensibility

Error: Commands return Result<T, String> (or serializable error), thiserror for Rust-side, serialize to String for IPC
Test: cargo test (Rust) + Vitest/Jest (frontend) | Unit: command logic | Integration: IPC round-trips | E2E: WebDriver
Structure: src-tauri/src/{main.rs,commands/,state.rs} + src/ (frontend)

Convention Block:
- #[tauri::command] for IPC — callable from frontend
- Scoped permissions in tauri.conf.json — minimal access
- tauri::State<T> for shared backend state
- thiserror for errors, serialize to String for IPC
- Separate Rust tests (cargo test) and frontend tests

Pitfalls:
- Exposing too many APIs in allowlist — security risk
- Blocking main thread with sync ops — use tokio::spawn
- Not registering commands in invoke_handler()
- Unhandled IPC errors — rejection on frontend
