---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*)
---

Create an implementation plan for: $ARGUMENTS

# PLANNING PROTOCOL

## STEP 1: UNDERSTAND

Read CLAUDE.md + current project structure. Check git status + recent changes.
Identify: stack, patterns, conventions, current state.

If vague, ask 1-2 clarifying questions. If clear, proceed.

## STEP 2: IMPACT ANALYSIS

Before writing the plan:
- Which existing files change? (list exact paths)
- What new files needed? (list)
- Dependencies between changes? (order)
- What could break? (risks)
- Does the matched framework reference file flag relevant pitfalls?

## STEP 3: OUTPUT PLAN

Save to `Plan.md`, output to chat:

```
## Plan: [short title]

### Summary
[1-2 sentences — what this achieves]

### Impact
- Modify: [file list]
- Create: [file list]
- Risks: [what could break]

### Phases
Phase 1: [name] — files: [list] — est. diffs: [lines]
  - [specific change 1]
  - [specific change 2]

Phase 2: [name] — files: [list] — est. diffs: [lines]
  - [specific change 1]
  - [specific change 2]

### Testing Strategy
- Per phase: [what to verify]
- Final: [end-to-end verification]

### Assumptions
- [ASSUMPTION: x]
```

## PLAN RULES
- Each phase independently testable
- Max 5 files per phase
- 2-5 phases for features, 1-2 for bug fixes
- Phase diffs under 200 lines
- Exact file paths, not vague descriptions
- Reference existing patterns: "Follow pattern in [file]"
- Always include testing strategy

## ERROR RECOVERY
If a phase fails after 2 fix attempts:
1. STOP — state root cause explicitly
2. Offer: **A)** rollback + different approach **B)** user decides
3. Never loop: fix → break → fix → break

## AFTER APPROVAL
Per phase:
1. Execute changes
2. Build + lint + test
3. `git add [files] && git commit -m "[phase description]"`
4. Update Plan.md with ✅
5. Next phase

If context grows long, suggest `/clear` with: `Read CLAUDE.md and Plan.md. Continue with next unchecked phase.`
