---
allowed-tools: Bash(*), Edit(**)
---

Migrate this project: $ARGUMENTS

# MIGRATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **From:** current framework/version/pattern (detect if not specified)
- **To:** target framework/version/pattern
- **Scope:** full project | specific directory | specific feature

Common migrations:
- Framework version: Pages Router → App Router, Vue Options → Composition, Angular modules → standalone
- Framework swap: Express → Hono, REST → GraphQL, Jest → Vitest
- Language: JavaScript → TypeScript, Python 2 → 3
- Pattern: class components → hooks, Redux → Zustand, callbacks → async/await

If unclear (missing "from" or "to"), ask. If clear, proceed.

## STEP 2: ANALYZE CURRENT STATE (read-only)

1. Read CLAUDE.md + project structure
2. Use **frameworks/_index.md** to load both source and target framework reference files
3. Detect current patterns: imports, config files, API usage, test setup
4. Inventory migration surface:
   - Files using old API/pattern (count + list)
   - Config files that change
   - Dependencies to add/remove
   - Breaking changes between source → target
5. Check both framework reference files' **Pitfalls** sections for migration-relevant traps

## STEP 3: MIGRATION PLAN (no code yet)

Save to `Migration-Plan.md`, output to chat:

```
## Migration: [from] → [to]

### Surface Area
- Files to migrate: [count] ([list top 10, "and N more" if >10])
- Config changes: [list]
- Deps add: [list] | Deps remove: [list]

### Breaking Changes
- [change 1 — what breaks + fix approach]
- [change 2]

### Strategy: [incremental | big-bang]
Incremental = both old + new coexist during migration (preferred for large projects)
Big-bang = single pass (acceptable for <20 files or version bumps)

### Phases
Phase 1: [name] — files: [list] — [what changes]
Phase 2: [name] — files: [list] — [what changes]
...

### Rollback Plan
- Git branch: migrate/[from]-to-[to]
- Checkpoint commit after each phase
- Rollback: `git reset --hard [phase-N-commit]`

### Verification
- Per phase: [what to check]
- Final: full build + lint + test + manual smoke test
```

STOP and wait for approval.

## STEP 4: EXECUTE (after approval)

```bash
git checkout -b migrate/[from]-to-[to]
```

Per phase:
1. Apply changes (update imports, APIs, configs, types)
2. Run build → fix errors (expect many — this is normal)
3. Run lint → fix errors
4. Run test → fix failures (update test APIs if testing framework changed)
5. `git add [files] && git commit -m "migrate phase [N]: [description]"`
6. Update Migration-Plan.md with ✅
7. Show: files changed, errors fixed, tests passing

**Coexistence Mode** (incremental strategy):
- Keep old + new working simultaneously during transition
- Use adapter/shim patterns if needed (temporary — track for removal)
- Remove old code only after new code passes all tests

**Error Recovery:** If phase fails after 2 fix attempts:
1. STOP — state root cause
2. Offer: **A)** `git reset --hard HEAD~1` + different approach **B)** skip file + flag for manual review **C)** user decides
3. Never force-fix — some migrations need manual judgment

## STEP 5: CLEANUP

After all phases:
1. Remove shims, adapters, compatibility layers
2. Remove old dependencies from package manager
3. Update config files (tsconfig, eslint, etc.)
4. Update CLAUDE.md with new conventions
5. Full build + lint + test
6. Final commit

## STEP 6: OUTPUT SUMMARY

```
## Migration Complete: [from] → [to]

### Stats
Files migrated: [count] | Phases: [count] | Tests: [pass/fail]

### What Changed
- [key change 1]
- [key change 2]

### Manual Review Needed
- [any skipped files or edge cases]

### Updated
- CLAUDE.md — new conventions
- Dependencies — [added/removed]

### Next Steps
- /review — verify migration quality
- [framework-specific post-migration task]
```

## MIGRATION RULES
- **Always branch first** — never migrate on main
- **Checkpoint every phase** — migration is inherently risky
- **Prefer incremental** — coexistence > big-bang for >20 files
- **Update tests alongside code** — don't leave broken tests for later
- **Preserve behavior** — migration changes implementation, not functionality
- **Don't "improve" during migration** — refactors come after, not during
- **Framework refs are your map** — Convention Blocks show the target patterns
