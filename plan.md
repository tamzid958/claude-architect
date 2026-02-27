---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*)
---

Create an implementation plan for: $ARGUMENTS

# CLAUDE ARCHITECT — PLANNING PROTOCOL

## STEP 1: UNDERSTAND THE REQUEST

Read CLAUDE.md and the current project structure to understand:
- What stack/framework is this project using?
- What patterns and conventions exist?
- What's the current state (check git status, recent changes)?

If the request is vague, ask clarifying questions:
```
Before I plan, a couple of questions:
1. [specific question about scope]
2. [specific question about approach]
```

If clear, proceed directly.

## STEP 2: ANALYZE IMPACT

Before writing the plan, assess:
- **Which existing files need to change?** (list them)
- **What new files are needed?** (list them)
- **Are there dependencies between changes?** (order matters)
- **What could break?** (identify risks)

## STEP 3: OUTPUT THE PLAN

Save the plan to `Plan.md` (create or update), then output to chat:

```
## Plan: [short title]

### Summary
[1-2 sentences — what this plan achieves]

### Impact Analysis
- Files to modify: [list]
- Files to create: [list]
- Risk areas: [what could break]

### Phases
Phase 1: [name] — files: [list] — est. diffs: [lines]
  - [specific change 1]
  - [specific change 2]

Phase 2: [name] — files: [list] — est. diffs: [lines]
  - [specific change 1]
  - [specific change 2]

...

### Testing Strategy
- [what to test after each phase]
- [what to test at the end]

### Assumptions
- [ASSUMPTION: any inference you made]
```

## PLAN RULES

- Each phase is independently testable
- No phase touches more than 5 files
- Total phases: 2-5 for features, 1-2 for bug fixes
- Keep each phase diff under 200 lines
- List exact file paths, not vague descriptions
- Reference existing patterns: "Follow pattern in [file]"
- Always include a testing strategy

## AFTER APPROVAL

When the user approves, implement one phase at a time:
1. Execute the phase
2. Run build + lint + test
3. Git commit: `git commit -m "[phase description]"`
4. Update Plan.md with ✅
5. Proceed to next phase

If a phase fails after 2 fix attempts, STOP and diagnose — don't loop.
