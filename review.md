---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(git show:*)
---

Review code: $ARGUMENTS

# CODE REVIEW PROTOCOL

## STEP 1: SCOPE

Determine from $ARGUMENTS:
- **No args** → uncommitted changes (`git diff` + `git diff --staged`)
- **Branch** → diff vs main/master (`git diff main...[branch]`)
- **File path(s)** → specific files
- **"last commit"** → `git show HEAD`
- **PR number** → `gh pr diff [number]` if gh available

If unclear, ask what to review.

## STEP 2: CONTEXT

Load before reviewing:
- CLAUDE.md (project conventions)
- Changed files + surrounding context (imports, tests, related files)
- Matched framework reference file from frameworks/ — check its Pitfalls section
- Recent git log for change context

## STEP 3: REVIEW

**Only flag real issues — no nitpicking.**

### Red — Bugs & Correctness (always flag)
- Logic errors, off-by-one, null/undefined access
- Race conditions, missing await, unhandled promises
- Wrong variable/function, missing edge cases causing runtime failures

### Yellow — Security (always flag)
- Hardcoded secrets/keys/credentials
- Injection (SQL, XSS, CSRF), missing input validation
- Missing auth/authorization checks
- Framework-specific pitfalls (from reference file's Pitfalls section)

### Yellow — Performance (flag if significant)
- N+1 queries, missing indexes, missing pagination
- Unnecessary re-renders, large allocations in hot paths

### Blue — Design (flag if notable)
- Violations of CLAUDE.md conventions
- Dead code, unused imports, missing error handling
- Functions doing too many things, missing types

### White — Style (only if violates CLAUDE.md)
- Don't flag personal preferences
- Don't suggest unrelated refactors

## STEP 4: OUTPUT

```
## Code Review: [scope]

### Summary
[1-2 sentences — overall: looks good / needs changes / critical issues]

### Red — Must Fix
[numbered — bugs + security, with file:line + why + suggested fix]

### Yellow — Should Fix
[numbered — perf, security hardening, missing validation]

### Blue — Suggestions
[numbered — design improvements]

### Green — What Looks Good
[2-3 positives]
```

## REVIEW RULES
- **Specific:** file path + line context for every issue
- **Explain why:** consequence, not just "this is wrong"
- **Suggest fixes:** show the fix or describe approach
- **Prioritize:** Red > Yellow > Blue — don't bury bugs under nits
- **Proportional:** 5-line change doesn't need 20 suggestions
- **No false positives:** unsure = "potential issue", not "bug"
- **Framework pitfalls:** cross-reference the Pitfalls section of the matched framework reference

## AUTO-FIX

If user says "fix it" / "apply fixes":
1. Fix Red + Yellow only (unless told otherwise)
2. Run build + lint + test
3. Show summary of changes
4. Don't touch unflagged code

## AFTER REVIEW
Suggest relevant next commands based on findings:
- /test — if coverage gaps found
- /refactor — if structural issues flagged
- /secure — if security concerns raised
- /perf — if performance issues noted
- /deps — if dependency issues found
