# Rust
> Senior Rust systems architect. Inherits: global-CLAUDE.md

Detection: Cargo.toml | .rs
Package Manager: Cargo (Cargo.toml + Cargo.lock)
Commands: dev=`cargo run` build=`cargo build --release` test=`cargo test` lint=`cargo clippy -- -D warnings` format=`cargo fmt` check=`cargo check` bench=`cargo bench`

Conventions:
- Ownership + borrowing — respect the borrow checker, don't fight it
- Result<T,E> for fallible ops, Option<T> for nullable — never unwrap() in production
- ? operator for error propagation — expect("reason") only in tests
- Pattern matching: match for exhaustive, if let for single-variant
- Traits over inheritance — define behavior via traits
- snake_case functions/variables, PascalCase types/traits, SCREAMING_SNAKE constants
- #[derive(Debug, Clone, PartialEq)] on most types
- Iterators: .iter().map().filter().collect() over manual loops
- Lifetimes: elide when possible, annotate only when compiler requires
- Cargo workspaces for multi-crate projects

Error: thiserror for library errors (derive Error), anyhow for app errors (.context()), From trait for conversions, never panic! in library code
Testing: Built-in #[cfg(test)] mod tests | tests/ for integration | assert!/assert_eq! | criterion for benchmarks | proptest for property testing
Architecture: src/{main.rs, lib.rs, models/, services/, handlers/, error.rs} | tests/ | benches/

.gitignore:
/target **/*.rs.bk .env *.log .DS_Store

Pitfalls:
- .unwrap() in non-test code — panics at runtime
- Fighting borrow checker with Rc<RefCell<T>> when restructuring is cleaner
- Not running cargo clippy — misses correctness issues
- String everywhere instead of &str for params (unnecessary allocation)
