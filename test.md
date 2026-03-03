---
allowed-tools: Bash(*), Edit(**)
---

Generate tests for: $ARGUMENTS

# TEST GENERATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Target:** file(s), function(s), module(s), endpoint(s), or "project" (coverage gaps)
- **Type:** unit | integration | e2e | "all needed"
- **Scope:** specific function | file | module | full coverage audit

If $ARGUMENTS is vague ("add tests"), ask:
```
1. What to test? (specific file/module or whole project coverage gaps)
2. What type? (unit / integration / e2e / all)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md — check existing test conventions, test commands, test file patterns
2. Load matched framework reference file — check **Testing** section for framework tools + patterns
3. Read target code thoroughly: functions, branches, edge cases, error paths
4. Read existing tests (if any) — match style, helpers, fixtures, naming
5. Identify untested code paths:
   - Functions with no corresponding test
   - Branches (if/else, switch) not covered
   - Error/exception paths
   - Edge cases: empty input, null, boundary values, concurrent access

**Output analysis:**
```
## Test Plan: [target]

### Stack
Test runner: [vitest/jest/pytest/go test/etc.] | Assertion: [built-in/chai/etc.]
Pattern: [co-located *.test.ts / __tests__/ / tests/ directory]

### Coverage Gaps
- [function/path 1] — not tested
- [function/path 2] — happy path only, missing error cases
- [function/path 3] — no edge cases

### Test Count
Unit: [N] | Integration: [N] | E2E: [N]
```

STOP and wait for approval.

## STEP 3: GENERATE

Per test file:
1. Follow existing test patterns exactly (naming, structure, helpers, imports)
2. Write tests in order: happy path → error paths → edge cases
3. Run tests → fix failures
4. Verify new tests actually test the right thing (not just passing by accident)

### Test Quality Rules

**Every test must:**
- Test one behavior (not implementation details)
- Have a descriptive name: `should [behavior] when [condition]`
- Be independent — no test depends on another test's state
- Be deterministic — no flaky tests, no timing-dependent assertions

**Unit tests:**
- Mock external dependencies (DB, HTTP, filesystem) at module boundaries
- Don't mock the thing you're testing
- Test public API, not private internals
- Cover: valid input, invalid input, boundary values, error cases

**Integration tests:**
- Use real dependencies where feasible (test DB, test server)
- Test component interactions, not individual functions
- Test the contract between modules

**E2E tests:**
- Test critical user flows only (don't duplicate unit test coverage)
- Use page objects or test helpers for UI tests
- Keep short — long E2E tests are fragile

### Framework-Specific Patterns

Follow the framework reference file's Testing section:
- **React/Vue/Svelte:** testing-library for components, MSW for API mocking
- **Next.js/Nuxt/SvelteKit:** separate unit (components) from integration (API routes)
- **FastAPI/Django/Rails:** test client for endpoints, factory fixtures for data
- **Go:** table-driven tests, testify for assertions
- **Rust:** #[cfg(test)] modules, mockall for traits

## STEP 4: VERIFY

After all tests written:
1. Run full test suite — all pass (new + existing)
2. Check: do new tests fail when the code is broken? (Mutation check — temporarily break the code, verify test catches it)
3. No skipped tests, no `todo!()`, no `test.skip`
4. Commit: `git add [test files] && git commit -m "test: add [what] tests"`

## STEP 5: OUTPUT SUMMARY

```
## Tests Generated: [target]

### Added
- [test file 1] — [N] tests ([what they cover])
- [test file 2] — [N] tests ([what they cover])

### Coverage
Before: [if measurable] → After: [if measurable]
Paths covered: happy path, error handling, edge cases

### Run
`[test command]` — all passing

### Not Covered (out of scope)
- [any gaps left intentionally, e.g., "E2E for payment flow needs Stripe test keys"]
```

## TEST RULES
- **Match existing patterns** — don't introduce a new test style into an existing project
- **Test behavior, not implementation** — tests should survive refactoring
- **No test without assertion** — `expect()` or `assert` in every test
- **No snapshot abuse** — snapshots are for stable output (serialized data), not DOM structure
- **Mock at boundaries** — mock HTTP/DB/filesystem, not internal functions
- **Tests must fail correctly** — a test that always passes is worthless
- **Don't test the framework** — test your code, not that React renders or Express routes
- **Readable > DRY in tests** — some repetition is fine if it makes tests clearer
