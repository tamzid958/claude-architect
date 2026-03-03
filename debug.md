---
allowed-tools: Bash(*), Edit(**)
---

Debug this issue: $ARGUMENTS

# DEBUGGING PROTOCOL

## STEP 1: DEFINE THE BUG

Extract from $ARGUMENTS:
- **Symptom:** what's happening (error message, wrong behavior, crash)
- **Expected:** what should happen
- **Repro steps:** how to trigger it (if known)
- **Scope:** file path, endpoint, component, or "unknown"

If $ARGUMENTS is vague ("it's broken"), ask:
```
1. What's the error message or unexpected behavior?
2. When did it start? (recent change, always broken, intermittent)
3. Can you reproduce it? (steps or command)
```

If clear, proceed.

## STEP 2: GATHER CONTEXT

1. Read CLAUDE.md + identify stack
2. Load matched framework reference file from **frameworks/_index.md** — check **Pitfalls** first
3. Read error logs, stack traces, browser console output
4. Check recent git changes: `git log --oneline -10` + `git diff HEAD~3`
5. Read the failing code + its tests + its imports

**Framework pitfalls shortcut:** Many bugs are known framework gotchas. Check the Pitfalls section before deep-diving — it may be a 1-line fix.

## STEP 3: HYPOTHESIZE

List 2-4 ranked hypotheses:
```
## Bug: [short description]

### Hypotheses (most likely first)
1. [hypothesis] — evidence: [why] — test: [how to confirm/deny]
2. [hypothesis] — evidence: [why] — test: [how to confirm/deny]
3. [hypothesis] — evidence: [why] — test: [how to confirm/deny]
```

**Rules:**
- Most likely first (Occam's razor — recent changes > obscure bugs)
- Each hypothesis must have a testable prediction
- Check framework Pitfalls before inventing exotic theories
- "Works on my machine" → check env vars, node_modules, lock files, .env

## STEP 4: ISOLATE

Test hypotheses in order:
1. Add minimal logging/assertions to confirm or eliminate each hypothesis
2. Narrow scope: which file, which function, which line
3. Find the **root cause**, not just the symptom

**Isolation techniques:**
- Binary search: comment out half the code, does it still break?
- Minimal repro: smallest code that triggers the bug
- Git bisect: `git bisect start HEAD [last-good-commit]` for regressions
- Dependency check: `rm -rf node_modules && npm install` (or equivalent)

## STEP 5: FIX

Once root cause is confirmed:
1. `git stash` or commit current debug artifacts
2. Write the fix — minimal, targeted, no scope creep
3. Remove debug logging/assertions
4. Run build + lint + test
5. Verify the original repro steps now pass
6. Check for related instances: does this bug pattern exist elsewhere?

**If fix breaks other things:** STOP. The root cause analysis was incomplete. Go back to Step 3.

## STEP 6: PREVENT

After fixing:
1. Add a regression test covering the exact bug
2. If it's a framework pitfall not in the reference file — note it
3. Commit: `git commit -m "fix: [what was broken] — [root cause]"`

## STEP 7: OUTPUT SUMMARY

```
## Bug Fixed: [short description]

### Root Cause
[1-2 sentences — the actual problem]

### Fix
[file:line — what changed and why]

### Regression Test
[test file — what it verifies]

### Related
- [other places this pattern exists, if any]
- [framework pitfall reference, if applicable]
```

## DEBUG RULES
- **Reproduce first** — can't fix what you can't trigger
- **Hypothesize before hacking** — random changes waste tokens and time
- **One change at a time** — change, test, observe, repeat
- **Root cause, not symptom** — "adding a null check" isn't a fix if the value shouldn't be null
- **Never suppress errors** — catch blocks that swallow exceptions create the next bug
- **Check framework pitfalls early** — 40% of bugs are documented gotchas
- **2-attempt limit per hypothesis** — if a fix doesn't work twice, re-hypothesize
- **Clean up debug artifacts** — remove console.logs, print statements, temporary code
