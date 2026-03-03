---
allowed-tools: Bash(*), Edit(**)
---

Onboard this existing project for Claude Architect: $ARGUMENTS

# ONBOARDING PROTOCOL

## STEP 1: ANALYZE (read-only — modify nothing)

### 1a. Detect Stack
Check package/config files. Use **frameworks/_index.md** detection matrix to identify language, framework. Read the matched framework reference file.

Extract: Language + version | Framework + version | Package manager | Key dependencies

### 1b. Map Structure
```bash
find . -maxdepth 3 -type f | grep -v 'node_modules\|.git\|__pycache__\|.next\|dist\|build\|vendor\|target\|.gradle\|Pods\|.dart_tool' | head -80
```
Identify: entry point(s), source dirs, test dirs, config files, build output

### 1c. Detect Patterns
Read 3-5 representative source files. Cross-reference with framework reference file.
Identify: code style, architecture pattern, error handling, testing pattern, state management

### 1d. Find Commands
Check: package.json scripts, Makefile, pyproject.toml [tool.*], Taskfile, Rakefile, build.gradle, Justfile
Identify: dev, build, test (full + single), lint, migrations, other
If not found, use defaults from matched framework reference file.

### 1e. Git State
```bash
git status && git log --oneline -10 && git branch -a
```

## STEP 2: ANALYSIS REPORT (before generating anything)

```
## Project Analysis: [name]

### Stack
Language: [x] | Framework: [x] | PM: [x] | Key deps: [top 5-8]
Framework ref: frameworks/[lang]/[framework].md

### Structure
[annotated directory tree]

### Detected Patterns
Architecture: [x] | Code style: [x] | Error handling: [x] | Testing: [x]

### Commands
Dev: `x` | Build: `x` | Test: `x` | Lint: `x`

### Git: Branch [x] | Clean: [y/n] | Recent: [last 3 commits]

### Issues Found
- [missing tests/linter/.gitignore]
- [deviations from framework best practices]

I'll generate CLAUDE.md and docs based on this. Proceed?
```

## STEP 3: INSTALL GLOBAL CLAUDE.md

Check `~/.claude/CLAUDE.md`:
- **Missing** → install from global-CLAUDE.md template
- **Exists** → compare, show diff, ask: merge / keep yours / replace

## STEP 4: GENERATE PROJECT CLAUDE.md

Combine: framework conventions (from reference file) + project-specific overrides (from analysis).

```markdown
# [Project Name]

## What
[One line — from package.json description, README, or analysis]

## Stack
[Language + framework + key deps — detected versions]

## Commands
- `[dev]` — run locally
- `[build]` — production build
- `[test]` — full test suite
- `[single-test]` — one test file
- `[lint]` — lint + format

## Structure
[Annotated directory layout]

## Conventions
### [Framework]-Specific
[From frameworks/[lang]/[framework].md Convention Block]

### Project-Specific (detected)
- [Naming convention]
- [Import style]
- [Error handling pattern]
- [Testing pattern]
- [State/data pattern]

## Key Files
- Entry: [path]
- Config: [path]
- Routes/API: [path]
- Models: [path]

## When Stuck
- For [area], look at [path] as reference
- Framework ref: frameworks/[lang]/[framework].md
```

**Keep under 80 lines.** Details go in docs/.

## STEP 5: GENERATE DOCS

Create relevant docs/ files only:

**docs/architecture.md** — overview, layer diagram, key decisions, data flow
**docs/conventions.md** — naming, file structure, error handling, testing patterns
**docs/api-patterns.md** (if API) — endpoint structure, validation, response format, auth, errors

Skip irrelevant docs (no api-patterns for CLIs, no architecture for simple scripts).

## STEP 6: HOOKS (optional)

Offer if lint/test commands exist:
```
Want automatic quality checks? (.claude/hooks.json)
- Runs [linter] after editing [file-types]
- Runs build + test before commits
Say "add hooks" or skip.
```

## STEP 7: PERMISSIONS (optional)

Offer permission allowlists for detected safe commands (.claude/settings.json).

## STEP 8: SUMMARY

```
## Onboarded: [name]

### Generated
- CLAUDE.md — conventions + commands
- docs/architecture.md, docs/conventions.md [, docs/api-patterns.md]
[- .claude/hooks.json, .claude/settings.json]
[- ~/.claude/CLAUDE.md (if installed)]

### What Claude Knows
Stack: [x] | Framework ref: [x] | [N] conventions | [N] commands | Architecture: [x]

### Next Steps
1. Review CLAUDE.md — fix anything wrong
2. /secure — security audit
3. /deps — check for outdated/vulnerable dependencies
4. /review — initial code health check
5. /plan [feature] — start building
```

## RULES
- **Never modify source code** during onboarding — only create CLAUDE.md, docs/, .claude/
- **If CLAUDE.md exists** → read, merge findings, ask before overwrite
- **Detected patterns > assumed defaults** — follow the codebase, not the template
- **Framework refs are guides, not gospel** — codebase contradicts ref → follow codebase
- **Be honest about uncertainty** — say "unclear" rather than guess
