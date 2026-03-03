---
allowed-tools: Bash(*), Edit(**)
---

Refactor: $ARGUMENTS

# REFACTORING PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **What:** file(s), function(s), module(s), or pattern to refactor
- **Why:** readability, performance, duplication, architecture, tech debt
- **Scope:** single file | module | cross-cutting

Common refactors:
- Extract: function, component, module, service
- Rename: variable, function, file (project-wide)
- Restructure: split file, merge files, reorganize directory
- Pattern: replace inheritance with composition, callbacks → async/await, imperative → declarative
- Decouple: separate concerns, extract interfaces, dependency injection

If $ARGUMENTS is vague ("clean up this code"), ask:
```
1. What specifically should improve? (readability / performance / architecture)
2. What scope? (this file / this module / project-wide)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md + understand project conventions
2. Load matched framework reference file — check **Convention Block** for target patterns
3. Read all code in refactor scope + its tests + its callers
4. Map dependencies: what imports this? what does this import?

**Output analysis:**
```
## Refactor: [short title]

### Current State
- [what the code does now]
- [why it needs refactoring — concrete problems]

### Dependency Map
- Used by: [list callers/importers]
- Depends on: [list dependencies]

### Risk Assessment
- Breaking changes: [yes/no — what could break]
- Test coverage: [existing tests that verify behavior]
```

## STEP 3: PLAN (no code yet)

```
### Refactor Plan
Strategy: [approach — e.g., "extract service, update callers, remove old code"]

Phase 1: [name] — files: [list]
  - [change 1]
  - [change 2]
  Verify: [how to confirm behavior unchanged]

Phase 2: [name] — files: [list]
  - [change 1]
  Verify: [check]
```

**Rules:**
- Max 5 files per phase
- Each phase: behavior must remain identical (tests pass)
- Refactors change structure, not behavior — if behavior changes, it's a feature
- Follow existing project conventions (from CLAUDE.md), not personal preferences

STOP and wait for approval.

## STEP 4: EXECUTE (after approval)

```bash
git checkout -b refactor/[short-description]
```

Per phase:
1. Apply structural changes
2. Update all callers/importers
3. Run build → fix errors
4. Run lint → fix errors
5. Run **full test suite** → all must pass (not just changed files)
6. `git add [files] && git commit -m "refactor: [phase description]"`
7. Next phase

**Critical rule:** If tests fail after a refactor step, the refactor introduced a bug. Fix it before continuing — never move to the next phase with failing tests.

**Error Recovery:** If phase fails after 2 fix attempts:
1. STOP — the refactor approach may be wrong
2. `git reset --hard HEAD~1`
3. Offer: **A)** different approach **B)** smaller scope **C)** user decides

## STEP 5: VERIFY

After all phases:
1. Full build + lint + test suite passes
2. Diff review: `git diff main...HEAD` — only structural changes, no behavior changes
3. No leftover dead code, unused imports, or orphaned files
4. Update CLAUDE.md if conventions changed (new module boundaries, renamed patterns)

## STEP 6: OUTPUT SUMMARY

```
## Refactored: [short title]

### Before → After
- [concrete improvement 1]
- [concrete improvement 2]

### Files Changed
[count] files across [count] commits

### Verified
- All tests pass | Build clean | Lint clean
- Behavior unchanged: [how confirmed]

### Next Steps
- /review — verify refactor quality
- [any follow-up refactors identified but out of scope]
```

## REFACTOR RULES
- **Tests pass at every step** — if they don't, you broke something
- **Behavior is sacred** — refactoring changes structure, never functionality
- **Small steps** — rename first, then move, then restructure. Not all at once
- **Follow the codebase** — match existing patterns from CLAUDE.md, don't impose new ones
- **Don't refactor and feature simultaneously** — one or the other per branch
- **Kill dead code** — if refactoring orphans code, delete it. Don't comment it out
- **Update callers immediately** — never leave broken imports for "later"
- **Framework conventions matter** — check Convention Block for idiomatic patterns
