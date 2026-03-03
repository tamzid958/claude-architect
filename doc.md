---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*)
---

Generate documentation for: $ARGUMENTS

# DOCUMENTATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Type:** API docs | architecture | component catalog | README | changelog | "all"
- **Scope:** whole project | module | specific feature
- **Audience:** developers (internal) | API consumers (external) | end users

If $ARGUMENTS is vague ("document this"), ask:
```
1. What type? (API reference / architecture overview / README / all)
2. For whom? (your team / external developers / end users)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md + project structure
2. Load matched framework reference file
3. Read source code in scope: public APIs, types/interfaces, route definitions, exports
4. Read existing docs (if any) — extend, don't duplicate
5. Check git log for recent changes (relevant for changelogs)

## STEP 3: GENERATE

### API Reference (if API project)

For each endpoint/route:
```
### [METHOD] [path]
[One-line description]

**Auth:** [required/optional/none]
**Request:** [body/params/query — with types]
**Response:** [status codes + body shape]
**Example:**
  Request: [curl or code]
  Response: [JSON]
```

Source: read route files + validation schemas + response types. Don't invent — document what exists.

### Architecture Doc (docs/architecture.md)

```
## Architecture: [project name]

### Overview
[2-3 sentences — what this is and how it's structured]

### System Diagram
[ASCII diagram showing major components + data flow]

### Layers
[layer 1]: [responsibility] — [key files]
[layer 2]: [responsibility] — [key files]

### Data Flow
[request/event] → [component] → [component] → [response/output]

### Key Decisions
- [decision 1] — [why]
- [decision 2] — [why]
```

### Component Catalog (if UI project)

For each component:
```
### [ComponentName]
**Location:** [path]
**Props:** [name: type — description] (from types/interfaces)
**Usage:** [where it's used in the project]
```

### README.md

```
# [Project Name]
[One-line description]

## Quick Start
[3-4 commands: clone, install, configure, run]

## Stack
[language + framework + key deps]

## Development
[dev command, test command, lint command]

## Project Structure
[annotated tree, 10-15 lines max]

## Environment Variables
[table: name | description | required | default]

## Deployment
[link to deploy doc or 2-3 commands]

## Contributing
[branch convention, PR process, test requirements]
```

### Changelog (from git history)

```
## [version/date]
### Added
- [feature — PR/commit ref]
### Changed
- [change — PR/commit ref]
### Fixed
- [fix — PR/commit ref]
```

Source: `git log --oneline` grouped by type (feat/fix/refactor/docs from commit messages).

## STEP 4: VERIFY

1. All documented APIs/components actually exist in code (no stale docs)
2. Code examples compile/run (if included)
3. No secrets, internal URLs, or sensitive info in docs
4. Links work (relative paths to files, not absolute)
5. Commit: `git add [doc files] && git commit -m "docs: add [what]"`

## STEP 5: OUTPUT SUMMARY

```
## Docs Generated: [project name]

### Created
- [file 1] — [what it covers]
- [file 2] — [what it covers]

### Coverage
- [N] endpoints documented
- [N] components documented
- Architecture: [overview/detailed]

### Next Steps
- Review for accuracy — docs generated from code analysis, verify nuance
- /review — check for stale docs in future PRs
```

## DOC RULES
- **Document what exists** — read the code, don't assume or invent
- **DRY with code** — if types define the API shape, reference them, don't duplicate
- **No stale docs** — better no docs than wrong docs. Only document current behavior
- **Audience-aware** — internal devs need architecture, API consumers need endpoints, users need instructions
- **Examples over descriptions** — a curl command is worth 50 words of explanation
- **Keep docs close to code** — co-located docs stay current, separate wikis rot
- **ASCII diagrams > no diagrams** — a text box-and-arrow diagram is better than a paragraph describing flow
- **Never expose secrets** — scrub .env values, API keys, internal URLs from all docs
