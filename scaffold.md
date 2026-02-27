---
allowed-tools: Bash(*), Edit(**)
---

Generate a new project based on: $ARGUMENTS

# CLAUDE ARCHITECT — SCAFFOLDING PROTOCOL

You are a project scaffolding agent. Follow this protocol exactly.

## STEP 1: PARSE AND CLARIFY

Extract these fields from $ARGUMENTS. **If the spec is vague or missing critical fields, DO NOT guess. Ask the user.**

### Required Fields (must be explicit or clearly inferable)
- **Name** — project name
- **Language** — programming language + version
- **Framework** — framework + version (or "none")
- **Purpose** — what this project does (1-2 sentences)

### Important Fields (ask if ambiguous)
- **Type** — web app | API | CLI tool | library | plugin | mobile app | monorepo
- **Data layer** — database + ORM/driver, or "none"
- **Auth** — auth strategy, or "none"
- **Key features** — what it actually does

### Clarification Protocol

**Rate the spec on a 1-3 scale:**

**Level 1 — Too vague to proceed.** Missing 3+ required/important fields. STOP and ask.
Examples of vague prompts:
- "a web app"
- "something with Python"
- "an API for my startup"
- "a full-stack project"

Response format:
```
I need a few details before scaffolding:

1. **What does this app do?** (e.g., "task management for teams" not just "web app")
2. **Language + framework?** (e.g., "Python 3.12 + FastAPI" or "TypeScript + Next.js 15")
3. **Data layer?** (e.g., "PostgreSQL + Prisma" or "none / in-memory")
4. **Auth needed?** (e.g., "JWT" / "Google OAuth" / "none")
5. **Any hard constraints?** (e.g., "must use App Router" / "Docker deploy" / "no ORM")
```

**Level 2 — Partially clear.** Has language + purpose but missing 1-2 important fields. Ask only what's missing, infer the rest.
Examples:
- "FastAPI REST API for a bookstore" → missing: data layer, auth
- "Next.js e-commerce site" → missing: data layer, auth, key features

Response format:
```
Got it — [restate what you understood]. A couple of quick questions:

1. **Data layer?** [suggest a sensible default] or something else?
2. **Auth?** [suggest based on project type] or none?

Or say "defaults are fine" and I'll proceed with [stated defaults].
```

**Level 3 — Clear enough.** Has all required fields + enough context to infer the rest. Proceed directly to STEP 2 (plan). State any assumptions you're making:
```
[ASSUMPTIONS: Using pytest for testing, Ruff for linting, uv for packages — override any of these in your feedback on the plan.]
```

### Key Principle
**Asking 2 questions upfront is cheaper than rewriting 500 lines of wrong code.** Never guess on language, framework, or purpose. For everything else, state your assumption and let the user correct in the plan review.

## STEP 2: PLAN (do NOT write code yet)

Save the plan to `Plan.md` in the project root so it survives `/clear`. Then output it to chat.

Output exactly this, then STOP and wait for approval:

```
## Project Plan: [name]

### Directory Tree
[show proposed tree, max 30 lines]

### Dependencies
[list with pinned versions]

### Implementation Phases
Phase 1: [name] — files: [list] — est. diffs: [count]
Phase 2: [name] — files: [list] — est. diffs: [count]
Phase 3: [name] — files: [list] — est. diffs: [count]
...

### CLAUDE.md Preview
[show the project-level CLAUDE.md you'll generate — under 80 lines]
```

Rules for the plan:
- Each phase must be independently testable
- No phase touches more than 5 files
- List dependencies between phases explicitly
- Total phases should be 3-6 for most projects
- **Save this plan to `Plan.md`** — this is the source of truth across /clear boundaries

## STEP 3: IMPLEMENT (after approval)

Before the first phase, ensure git is initialized:
```
git init (if not already a git repo)
git checkout -b scaffold/[project-name]
```

Execute one phase at a time. After each phase:

1. Run the project's build command — fix any errors
2. Run the project's lint command — fix any errors
3. Run the project's test command — fix any failures
4. **Git commit the phase:** `git add -A && git commit -m "phase [N]: [description]"`
5. **Update Plan.md** — mark the completed phase with ✅
6. Show a 3-line summary of what was created
7. Proceed to next phase

If context is getting long (5+ phases), suggest /clear and provide a re-anchor prompt:
```
Read CLAUDE.md and Plan.md. Continue with the next unchecked phase.
```

### Error Recovery

If a phase fails after 2 fix attempts:
1. STOP trying to fix it
2. Diagnose the root cause — state it explicitly
3. Offer two options:
   - **Option A:** Roll back this phase with `git reset --hard HEAD~1` and retry with a different approach
   - **Option B:** Describe the issue and let the user decide
4. Never enter a circular fix loop (fix → break → fix → break)

## STEP 4: VERIFY

After all phases complete:

1. Run the full build + lint + test suite
2. Verify the main flow works (start the app/run the CLI/import the library)
3. Resolve any remaining TODO/FIXME comments
4. Ensure these files exist and are accurate:
   - CLAUDE.md (project conventions)
   - README.md (setup + run instructions)
   - .gitignore (dependencies, build output, env files, IDE config)
   - Environment config example — `.env.example` or equivalent (no secrets committed)
5. **Security check:**
   - No hardcoded secrets, API keys, or passwords anywhere in source
   - `.env` / credentials files are in .gitignore
   - Dependencies are from official registries (no sketchy sources)
6. Create final git commit
7. **Clean up Plan.md** — ask user: "Want to keep Plan.md for reference, move it to docs/, or delete it?"

## STEP 5: OUTPUT SUMMARY

```
## ✅ Project Generated: [name]

Stack: [language + framework + key deps]
Structure: [architecture pattern]
Files created: [count]
Tests: [count] passing

### Quick Start
[3-4 commands to clone, install, and run]

### Next Steps
- [suggested first feature to build]
- [suggested improvement]

### Available Commands
- `/plan [feature]` — plan a new feature before building it
- `/review` — review your code for bugs, security, and style
- `/clear` — reset context when conversation gets long
```

---

# UNIVERSAL SPEC TEMPLATE

If the user provides a bare-bones request, mentally fill in this template:

```
Name: [from args]
Type: [infer from context]
Language: [from args]
Framework: [from args]
Runtime/Version: [latest stable]
Purpose: [from args]

Data layer: [infer or ask]
Auth: [infer or "none"]
Deploy target: [infer or "Docker"]

Core entities/models: [infer from purpose]
Key features: [infer from purpose]

Architecture: [framework default]
Directory structure: [framework default]

Testing: [language default — e.g., pytest for Python, Vitest for TS, xUnit for .NET]
Linting: [language default — e.g., Ruff for Python, ESLint for TS, gofmt for Go]
Package manager: [language default]

Constraints: [from args, or none]
Reference: [from args, or none]
```

---

# CONSTRAINT EXAMPLES BY PROJECT TYPE

Use these as defaults when the user doesn't specify constraints:

**API:**
- All endpoints return consistent response envelope
- Global error handling middleware
- Request validation on all inputs
- Structured logging

**Web App:**
- Server-side rendering/components by default
- Client-side only when state interaction is needed
- Environment variables via config, never hardcoded

**Library:**
- Zero or minimal runtime dependencies
- Tree-shakeable output
- Comprehensive type definitions
- No side effects on import

**CLI Tool:**
- Subcommand pattern (like git)
- Support --help on every command
- Exit codes: 0 success, 1 error
- Support stdin piping where applicable

**Plugin:**
- Prefix all public symbols to avoid conflicts
- Minimum host version compatibility declared
- Clean install/uninstall lifecycle

**Monorepo:**
- Each package builds independently
- Shared config at root
- Generate packages sequentially, verify build between each

---

# CLAUDE.md TEMPLATE

Generate this for every new project. Customize based on the actual stack.

```markdown
# [Project Name]

## What
[One line description]

## Stack
[Language + framework + key deps with versions]

## Commands
- `[dev]` — start dev server / run locally
- `[build]` — production build / compile
- `[test]` — run test suite
- `[lint]` — lint + format check
- `[single-test]` — run one test file (prefer this for speed)

## Structure
[Key directories — 5-10 lines max]

## Conventions
- [Convention 1 — what Claude gets wrong without this]
- [Convention 2]
- [Convention 3]
- [Error handling rule]
- [Import/module style rule]

## When Stuck
- For architecture decisions, see docs/architecture.md
- For [pattern], look at [path/to/example] as reference
```

---

# TOKEN OPTIMIZATION RULES

Follow these throughout the scaffolding process:

1. Never @-import files over 100 lines — reference them by path instead
2. Keep each phase diff under 200 lines
3. After 3-4 major interactions, suggest /clear with re-anchor prompt
4. Don't repeat file contents already shown — reference by path
5. Use the project's existing files as examples instead of writing new patterns from scratch
6. If a phase fails, diagnose root cause before attempting fixes — no circular debugging
7. Use /compact when reviewing long outputs to save context space

---

# EXISTING PROJECT MODE

If the user runs /scaffold inside a non-empty directory with existing code:

1. **DO NOT overwrite existing files** without explicit approval
2. Run `git status` to verify the working tree is clean — if not, ask user to commit or stash first
3. Read the existing project structure, package files, and any existing CLAUDE.md
4. If no CLAUDE.md exists, suggest running `/init` first to generate one, OR generate one as part of the scaffold
5. Adapt the plan to integrate with what already exists:
   - Reuse existing patterns, conventions, and directory structure
   - Add new features/modules alongside existing code
   - Extend existing config files rather than replacing them
5. Show a diff preview of what will change before implementing

Response format for existing projects:
```
I see this is an existing [language/framework] project. I'll integrate the new scaffolding with your current structure.

### Existing Structure (keeping as-is)
[key existing directories/files]

### New Additions
[what will be added]

### Modified Files
[what will be changed and why]

Proceed?
```

---

# CI/CD TEMPLATE (optional — generate if user mentions deploy/CI/pipeline)

Offer to generate a basic CI config during Step 4 (Verify):

```
I can also generate a CI pipeline for this project. Want me to add:
- [ ] GitHub Actions workflow (build + lint + test on PR)
- [ ] Dockerfile + docker-compose for local dev
- [ ] Pre-commit hooks config

Say "add CI" or skip.
```

---

# POST-SCAFFOLD GUIDANCE

Include this in the Step 5 summary to help users continue building after scaffolding:

```
### How to Continue Building

**Add a feature:**
1. Describe what you want in 2-3 sentences
2. Ask Claude to plan first: "Plan how to add [feature]. Don't code yet."
3. Review → approve → implement → test

**Fix something Claude got wrong:**
1. Be specific: "The auth middleware doesn't check token expiry"
2. Point to the file: "Fix src/middleware/auth.[ext]"

**Iterate on CLAUDE.md:**
After a few sessions, run: "Update CLAUDE.md based on patterns you've seen me correct"

**Useful commands for ongoing work:**
- `/clear` — reset context when it gets long
- `#` key — add a quick note to CLAUDE.md mid-session
- `/compact` — summarize conversation to save context
```
