# Global Defaults

Install to `~/.claude/CLAUDE.md` — loads automatically in all sessions.

## Clarification First (Highest Priority)

- If requirements are vague or ambiguous, ask before coding — never guess on architecture, data models, or UX
- If multiple valid approaches exist, present options with trade-offs
- State assumptions explicitly: `[ASSUMPTION: using JWT for auth]` — ask if incorrect
- 2 questions upfront saves 200 lines of wrong code

## Model Guidance

- **Planning / Analysis** → Opus | **Execution / Implementation** → Sonnet
- Opus: `/plan`, `/review`, `/onboard`, `/debug`, `/migrate`, `/secure`, `/perf`
- Sonnet: `/scaffold`, `/refactor`, `/test`, `/deploy`, `/doc`, `/api`, `/component`, `/deps`

## Code Quality

- Modern language idioms, strict typing enabled, functional patterns preferred
- No magic numbers — extract named constants
- Functions do one thing — if you need "and" in the name, split it
- Early returns over deep nesting | Files under 300 lines
- Composition over inheritance | Language's standard module system

## Naming

- Variables/functions: describe what, not how — `getUserById` not `queryDB`
- Booleans: `is`, `has`, `should`, `can` prefix | Constants: UPPER_SNAKE_CASE
- Files: match language convention (kebab-case JS/TS, snake_case Python/Rust/Go, PascalCase C#/Java)

## Error Handling

- Use language's idiomatic pattern (Result types, try/catch, error returns)
- Include context: what failed, why, what caller should do
- At system boundaries, catch all errors and return structured responses — never expose internals

## Security

- Never hardcode secrets — env vars for all config with `.env.example` templates
- Validate all external input — sanitize output (XSS, SQL injection, command injection)
- Parameterized queries only — pin dependency versions
- `.env`, credentials, key files always in `.gitignore`

## Testing

- Write tests alongside implementation — test behavior, not implementation
- One assertion per test when practical — descriptive names: `should_return_404_when_user_not_found`
- Mock at boundaries (DB, APIs, filesystem), not internal functions
- **Types:** Unit (pure logic) | Integration (service-to-service) | E2E (critical paths) | Snapshot (UI/API shapes) | Contract (API agreements) | Perf (hot paths) | Security (auth, injection)
- **Before writing tests, propose:** what types needed, how many files/cases. Only write approved types.

## Git Workflow

- Branch before changes — never commit to main directly
- Commit per logical unit — explain why, not what
- Conventional prefixes: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`, `chore:`
- Build + lint + test before every commit

## Performance

- Correct first, fast second — profile before optimizing
- Paginate list endpoints — add indexes for WHERE/JOIN/ORDER BY columns
- Avoid N+1 queries — cache expensive idempotent computations

## Project Hygiene

- `.gitignore`: dependencies, build output, env files, IDE config, OS files
- Lock files go in git — build artifacts and dependencies never do
- Dead code gets deleted, not commented out — no unresolved TODO/FIXME

## Communication

- Plans: numbered step list, no prose
- Implementation: show file path before code
- Flag assumptions with `[ASSUMPTION]` — when stuck, state what failed and what to try next

## Quality Gates

- Build passes zero warnings | Linter passes zero errors
- All tests pass | No hardcoded secrets
- `.gitignore` complete | No unresolved TODO/FIXME
