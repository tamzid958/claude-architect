# Go
> Senior Go architect. Inherits: global-CLAUDE.md

Detection: go.mod | .go
Package Manager: Go modules (go.mod + go.sum)
Commands: dev=`go run ./cmd/app/` build=`go build -o bin/app ./cmd/app/` test=`go test ./...` lint=`golangci-lint run` format=`gofmt -w .` vet=`go vet ./...` tidy=`go mod tidy`

Conventions:
- Accept interfaces, return structs — narrow interfaces at call site
- Package names: short, lowercase, singular (user, config — not users, utils)
- if err != nil on every error — wrap with fmt.Errorf("context: %w", err)
- MixedCaps: Exported=PascalCase, unexported=camelCase, no underscores
- Keep main thin — cmd/app/main.go wires things, logic in packages
- Table-driven tests with t.Run() subtests
- context.Context as first param — never store in structs
- defer for cleanup — file.Close(), rows.Close(), tx.Rollback()
- Channels for communication, not shared memory
- //go:embed for static files and templates

Error: Always check errors, wrap with fmt.Errorf("doing X: %w", err), errors.Is/As for checking, panic only for unrecoverable
Testing: Built-in testing package | *_test.go same package | table-driven + testify | httptest for HTTP | BenchmarkX, FuzzX
Architecture: cmd/ for entrypoints, internal/ for private packages, pkg/ for public, api/ for HTTP handlers

.gitignore:
bin/ *.exe *.test *.out vendor/ .env *.log .DS_Store

Pitfalls:
- Ignoring errors from defer (capture in named return)
- Goroutine leaks — use context cancellation to ensure exit
- Data races — always run tests with -race flag
- Nil pointer from maps or DB — check before use
