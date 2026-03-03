---
allowed-tools: Bash(*), Edit(**)
---

Generate a new project based on: $ARGUMENTS

# SCAFFOLDING PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Required:** Name, Language, Framework, Purpose
- **Important (ask if ambiguous):** Type (web|API|CLI|lib|mobile|monorepo), Data layer, Auth, Key features

**Rate spec 1-3:**

**Level 1 — Too vague** (missing 3+ fields). STOP, ask:
```
I need details before scaffolding:
1. What does this app do? (not just "web app")
2. Language + framework? (e.g., "Python + FastAPI")
3. Data layer? (e.g., "PostgreSQL + Prisma" or "none")
4. Auth needed? (e.g., "JWT" / "OAuth" / "none")
5. Hard constraints? (e.g., "must use App Router" / "Docker deploy")
```

**Level 2 — Partial** (has language + purpose, missing 1-2). Ask only what's missing with sensible defaults.

**Level 3 — Clear**. Proceed. State assumptions: `[ASSUMPTION: pytest, Ruff, uv — override in plan review]`

**Principle:** 2 questions upfront < rewriting 500 lines of wrong code.

## STEP 2: PLAN (no code yet)

Use **frameworks/_index.md** to find the matching reference file. Read it.
Save plan to `Plan.md`, then output:

```
## Project Plan: [name]
### Directory Tree (max 30 lines)
### Dependencies (latest stable — no pinned versions)
### Phases
Phase N: [name] — files: [list] — est. diffs: [count]
### CLAUDE.md Preview (under 80 lines)
```

Rules: each phase independently testable | max 5 files per phase | 3-6 phases total | list phase dependencies explicitly
STOP and wait for approval.

## STEP 3: IMPLEMENT (after approval)

```bash
git init (if needed) && git checkout -b scaffold/[project-name]
```

Per phase:
1. Write code
2. Run build → fix errors
3. Run lint → fix errors
4. Run test → fix failures
5. `git add [specific files] && git commit -m "phase [N]: [description]"`
6. Update Plan.md with ✅
7. Show 3-line summary, proceed

**Error Recovery:** If phase fails after 2 fix attempts:
1. STOP — diagnose root cause explicitly
2. Offer: **A)** `git reset --hard HEAD~1` + retry different approach **B)** describe issue, let user decide
3. Never enter fix→break→fix loops

**Context Management:** After 5+ phases suggest `/clear` with re-anchor: `Read CLAUDE.md and Plan.md. Continue with next unchecked phase.`

## STEP 4: VERIFY

After all phases:
1. Full build + lint + test suite
2. Main flow works (start app / run CLI / import lib)
3. No unresolved TODO/FIXME
4. Files exist: CLAUDE.md, README.md, .gitignore, .env.example
5. Security: no hardcoded secrets, .env in .gitignore, official registries only
6. Final commit
7. Ask: keep Plan.md, move to docs/, or delete?

## STEP 5: OUTPUT SUMMARY

```
## Project Generated: [name]
Stack: [lang + framework + key deps]
Files created: [count] | Tests: [count] passing

### Quick Start
[3-4 commands: clone, install, run]

### Next Steps
- [suggested first feature]
- /plan [feature] — plan before building
- /test — add test coverage
- /deploy — generate deployment config
- /review — code health check
- /secure — security audit
```

---

## SPEC TEMPLATE (mental model for bare requests)

Name | Type | Language | Framework | Purpose | Data layer | Auth | Deploy target
Core entities | Key features | Architecture | Testing | Linting | Package manager | Constraints

---

## DEFAULT CONSTRAINTS BY TYPE

**API:** consistent response envelope, global error middleware, input validation, structured logging
**Web App:** SSR by default, client-side only for stateful interaction, env via config
**Library:** zero/minimal deps, tree-shakeable, comprehensive types, no import side effects
**CLI:** subcommand pattern, --help everywhere, exit codes 0/1, stdin piping support
**Monorepo:** independent package builds, shared root config, sequential generation with build verification

---

## CLAUDE.md TEMPLATE

```markdown
# [Project Name]

## What
[One line]

## Stack
[Language + framework + key deps — latest stable]

## Commands
- `[dev]` — run locally
- `[build]` — production build
- `[test]` — test suite
- `[lint]` — lint + format
- `[single-test]` — one test file

## Structure
[5-10 lines max]

## Conventions
- [What Claude gets wrong without this]
- [Error handling rule]
- [Import/module style]
```

---

## EXISTING PROJECT MODE

If non-empty directory with existing code:
1. DO NOT overwrite without approval
2. Verify clean git state — ask to commit/stash if dirty
3. Read existing structure + CLAUDE.md
4. Adapt plan to integrate: reuse patterns, extend configs, add alongside
5. Show diff preview before implementing

---

## TOKEN RULES

1. Never @-import files over 100 lines — reference by path
2. Phase diffs under 200 lines
3. Suggest /clear after 3-4 major interactions
4. Reference files by path, don't repeat contents
5. Use existing files as examples, don't write patterns from scratch
