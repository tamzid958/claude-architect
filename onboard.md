---
allowed-tools: Bash(*), Edit(**)
---

Onboard this existing project for Claude Architect: $ARGUMENTS

# CLAUDE ARCHITECT — ONBOARDING PROTOCOL

You are onboarding an existing codebase so Claude can work on it effectively. Follow this protocol exactly.

## STEP 1: ANALYZE THE PROJECT

Scan the project systematically. Do NOT modify anything yet.

### 1a. Detect Stack
```bash
# Check for package/config files to identify the stack
ls -la
cat package.json 2>/dev/null || cat requirements.txt 2>/dev/null || cat pyproject.toml 2>/dev/null || cat go.mod 2>/dev/null || cat Cargo.toml 2>/dev/null || cat composer.json 2>/dev/null || cat *.csproj 2>/dev/null || cat pom.xml 2>/dev/null || cat build.gradle 2>/dev/null
```

Extract:
- **Language + version**
- **Framework + version**
- **Package manager**
- **Key dependencies**

### 1b. Map the Structure
```bash
# Get directory tree (2 levels deep, ignore noise)
find . -maxdepth 3 -type f | grep -v node_modules | grep -v .git | grep -v __pycache__ | grep -v .next | grep -v dist | grep -v build | grep -v vendor | grep -v target | head -80
```

Identify:
- **Entry point(s)** — where does the app start?
- **Source directories** — where does code live?
- **Test directories** — where are tests? What framework?
- **Config files** — what tools are configured?
- **Build output** — what's generated vs. source?

### 1c. Detect Patterns
Read 3-5 representative source files to identify:
- **Code style** — indentation, naming conventions, import style
- **Architecture pattern** — MVC, Clean Architecture, feature-based, flat?
- **Error handling pattern** — how are errors handled?
- **Testing pattern** — unit tests, integration tests, test naming?
- **State management** — how is state/data managed?

### 1d. Find Commands
```bash
# Check for scripts/commands
cat package.json 2>/dev/null | grep -A 30 '"scripts"' || \
cat Makefile 2>/dev/null | grep '^[a-zA-Z]' || \
cat pyproject.toml 2>/dev/null | grep -A 20 '\[tool\.' || \
cat Taskfile.yml 2>/dev/null | head -40
```

Identify:
- **Dev command** — how to run locally
- **Build command** — how to build for production
- **Test command** — how to run tests (full suite + single test)
- **Lint command** — how to lint/format
- **Other commands** — migrations, seed, deploy, etc.

### 1e. Check Git State
```bash
git status
git log --oneline -10
git branch -a
```

## STEP 2: OUTPUT ANALYSIS REPORT

Show the user what you found before generating anything:

```
## 🔍 Project Analysis: [detected name]

### Stack
- Language: [language + version]
- Framework: [framework + version]
- Package manager: [manager]
- Key deps: [top 5-8 dependencies]

### Structure
[directory tree — key directories with purpose annotations]

### Detected Patterns
- Architecture: [pattern]
- Code style: [key observations — indentation, naming, etc.]
- Error handling: [pattern]
- Testing: [framework, location, naming convention]

### Commands Found
- Dev: `[command]`
- Build: `[command]`
- Test: `[command]`
- Lint: `[command]`

### Git Status
- Branch: [current branch]
- Clean: [yes/no]
- Recent activity: [last 3 commits summarized]

### Potential Issues
- [anything missing — no tests, no linter, no .gitignore, etc.]
- [inconsistencies found]

I'll now generate CLAUDE.md and project docs based on this analysis. Proceed?
```

## STEP 3: GENERATE CLAUDE.md

After user approval, create a project-level CLAUDE.md based on the analysis:

```markdown
# [Project Name]

## What
[One line — inferred from package.json description, README, or code analysis]

## Stack
[Language + framework + key deps with detected versions]

## Commands
- `[dev command]` — start dev server / run locally
- `[build command]` — production build / compile
- `[test command]` — run full test suite
- `[single test command]` — run one test file
- `[lint command]` — lint + format check
[any other detected commands]

## Structure
[Annotated directory layout — what each key directory does]

## Conventions (detected from codebase)
- [Naming convention — e.g., camelCase for variables, PascalCase for components]
- [Import style — e.g., absolute imports from src/, barrel exports]
- [Error handling pattern — e.g., custom AppError class, Result types]
- [Testing pattern — e.g., tests co-located, __tests__/ directory, .spec naming]
- [State/data pattern — e.g., repository pattern, hooks + context, Redux]

## Architecture
[Brief description of the architecture — e.g., "Clean Architecture with handler → service → repository layers"]

## Key Files
- [Entry point]: [path]
- [Config]: [path]
- [Routes/API]: [path]
- [Database/Models]: [path]
- [Shared types/utils]: [path]

## When Stuck
- For [area], look at [path/to/example] as reference
- For [area], see [path/to/docs] if available
```

## STEP 4: GENERATE PROJECT DOCS

Create a `docs/` directory with progressive disclosure files:

### docs/architecture.md
```markdown
# Architecture

## Overview
[2-3 sentences describing the overall architecture]

## Layer Diagram
[Text-based diagram showing the layers/modules and their relationships]

## Key Design Decisions
- [Decision 1 — inferred from code patterns]
- [Decision 2]
- [Decision 3]

## Data Flow
[How a request/action flows through the system — entry → processing → response]
```

### docs/conventions.md
```markdown
# Code Conventions

## Naming
- Files: [pattern — e.g., kebab-case, PascalCase]
- Variables: [pattern]
- Functions: [pattern]
- Types/Interfaces: [pattern]
- Constants: [pattern]

## File Structure
[How a typical file should be organized — imports, types, implementation, exports]

## Error Handling
[Detected error handling pattern with example reference]

## Testing
- Test location: [where tests live]
- Naming: [convention — e.g., *.test.ts, *_test.go, Test* prefix]
- Pattern: [e.g., AAA, Given-When-Then]
- Mocking: [approach used]
```

### docs/api-patterns.md (if API project)
```markdown
# API Patterns

## Endpoint Structure
[Detected route/endpoint pattern with example]

## Request Validation
[How inputs are validated]

## Response Format
[Detected response envelope/format]

## Authentication
[Detected auth pattern]

## Error Responses
[How errors are returned to clients]
```

Only generate docs files that are relevant to the project type. Skip api-patterns.md for CLIs, skip architecture.md for simple scripts, etc.

## STEP 5: SET UP HOOKS (optional)

If the project has lint/test commands, offer to create hooks:

```
Want me to set up automatic quality checks?

This will create .claude/hooks.json so Claude automatically:
- Runs [linter] after editing [file-types]
- Runs build + test before commits

Say "add hooks" or skip.
```

If approved, generate `.claude/hooks.json`:
```json
{
  "hooks": {
    "post-edit": [
      {
        "command": "[detected lint-fix command] ${file}",
        "pattern": "**/*.{[detected extensions]}"
      }
    ],
    "pre-commit": [
      {
        "command": "[detected build command] && [detected test command]"
      }
    ]
  }
}
```

## STEP 6: SET UP PERMISSIONS (optional)

Offer to create permission allowlists based on detected commands:

```
Want me to set up permission allowlists so Claude doesn't ask for approval on routine commands?

This will allow: [list of detected safe commands]

Say "add permissions" or skip.
```

If approved, generate `.claude/settings.json`.

## STEP 7: OUTPUT SUMMARY

```
## ✅ Project Onboarded: [name]

### Generated Files
- CLAUDE.md — project conventions and commands
- docs/architecture.md — system architecture overview
- docs/conventions.md — code style and patterns
[- docs/api-patterns.md — API endpoint conventions (if applicable)]
[- .claude/hooks.json — automatic quality checks (if approved)]
[- .claude/settings.json — permission allowlists (if approved)]

### What Claude Now Knows
- Stack: [summary]
- [N] conventions detected
- [N] commands mapped
- Architecture: [pattern]

### Available Commands
- `/plan [feature]` — plan a new feature before building it
- `/review` — review code for bugs, security, and style
- `/scaffold` — add new modules to this project

### Recommended First Steps
1. Review CLAUDE.md and fix anything I got wrong
2. Run `/review` to get an initial code health check
3. Start building: `/plan [your next feature]`
```

## ONBOARDING RULES

- **Never modify existing source code** during onboarding
- **Only create new files** (CLAUDE.md, docs/, .claude/)
- **If CLAUDE.md already exists**, read it, merge new findings, and ask before overwriting
- **If docs/ already exists**, don't overwrite — add new files alongside or ask
- **Prefer detected patterns over assumed defaults** — if the project uses tabs, don't suggest spaces
- **Be honest about uncertainty** — if you can't determine a pattern, say so rather than guessing
- **Keep CLAUDE.md under 80 lines** — put details in docs/ files
