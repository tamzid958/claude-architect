---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(git show:*)
---

Review code: $ARGUMENTS

# CLAUDE ARCHITECT — CODE REVIEW PROTOCOL

## STEP 1: DETERMINE SCOPE

Figure out what to review based on $ARGUMENTS:

- **No arguments** → review uncommitted changes (`git diff` + `git diff --staged`)
- **Branch name** → diff against main/master (`git diff main...[branch]`)
- **File path(s)** → review specific files
- **"last commit"** → review the most recent commit (`git show HEAD`)
- **PR number** → if gh CLI is available, fetch PR diff

If the scope is unclear, ask:
```
What should I review?
1. Uncommitted changes (git diff)
2. Current branch vs main
3. A specific file or directory
4. Last N commits
```

## STEP 2: READ CONTEXT

Before reviewing, load:
- CLAUDE.md (project conventions)
- The files being changed AND their surrounding context (imports, tests, related files)
- Recent git log for context on what's been happening

## STEP 3: REVIEW

Analyze the code across these dimensions. **Only flag real issues — don't nitpick.**

### 🔴 Bugs & Correctness (always flag)
- Logic errors, off-by-one, null/undefined access
- Race conditions, missing await, unhandled promises
- Wrong variable/function used
- Missing edge cases that would cause runtime failures

### 🟡 Security (always flag)
- Hardcoded secrets, API keys, credentials
- SQL injection, XSS, CSRF vulnerabilities
- Missing input validation on user-facing endpoints
- Insecure dependencies (if obvious)
- Missing auth/authorization checks

### 🟡 Performance (flag if significant)
- N+1 queries, missing indexes
- Unnecessary re-renders, missing memoization (if impactful)
- Large allocations in hot paths
- Missing pagination on list endpoints

### 🔵 Design & Maintainability (flag if notable)
- Violations of project conventions (from CLAUDE.md)
- Dead code, unused imports
- Missing error handling
- Functions doing too many things
- Missing types/interfaces where the project uses them

### ⚪ Style (only flag if violates CLAUDE.md conventions)
- Don't flag style preferences unless they contradict project conventions
- Don't suggest refactors unrelated to the change

## STEP 4: OUTPUT

Format the review as:

```
## Code Review: [scope description]

### Summary
[1-2 sentences — overall assessment: looks good / needs changes / has critical issues]

### 🔴 Must Fix
[numbered list — bugs and security issues that need fixing before merge]

### 🟡 Should Fix
[numbered list — performance, security hardening, missing validation]

### 🔵 Suggestions
[numbered list — design improvements, nice-to-haves]

### ✅ What Looks Good
[2-3 things done well — positive reinforcement is useful]
```

## REVIEW RULES

- **Be specific:** Include file path + line context for every issue
- **Explain why:** Don't just say "this is wrong" — explain the consequence
- **Suggest fixes:** For each issue, show the fix or describe the approach
- **Prioritize:** 🔴 > 🟡 > 🔵 — don't bury critical bugs under style nits
- **Be proportional:** A 5-line change doesn't need 20 suggestions
- **Respect conventions:** Only flag style issues that violate CLAUDE.md, not personal preference
- **No false positives:** If you're not sure something is a bug, say "potential issue" not "bug"

## AFTER REVIEW

If the user says "fix it" or "apply fixes":
1. Fix only 🔴 and 🟡 items (unless user says otherwise)
2. Run build + lint + test after fixes
3. Show a summary of what was changed
4. Don't touch code that wasn't flagged in the review
