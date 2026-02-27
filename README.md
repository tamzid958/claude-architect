# Claude Architect

A plug-and-play framework for generating projects with Claude Code CLI — optimized for speed, token efficiency, and consistent output across any language or framework.

**Version:** 1.0.0 | **Last Updated:** February 2026 | **License:** MIT

### Changelog

- **1.0.0** — Initial release. Scaffold, plan, review commands. Global CLAUDE.md. Full README with model selection, MCP servers, CI/CD, and troubleshooting.

---

## What's Included

| File | Location | Purpose |
|------|----------|---------|
| `global-CLAUDE.md` | `~/.claude/CLAUDE.md` | Lightweight defaults loaded every session (~25 lines) |
| `scaffold.md` | `~/.claude/commands/scaffold.md` | Full scaffolding protocol loaded only when you invoke `/scaffold` |
| `plan.md` | `~/.claude/commands/plan.md` | Standalone planning command for features and changes (`/plan`) |
| `review.md` | `~/.claude/commands/review.md` | Code review command for PRs, branches, or specific files (`/review`) |

---

## Installation

```bash
# 1. Back up existing global CLAUDE.md (if you have one)
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak

# 2. Copy global defaults (loaded every session — low token cost)
cp global-CLAUDE.md ~/.claude/CLAUDE.md

# 3. Create commands directory if it doesn't exist
mkdir -p ~/.claude/commands

# 4. Copy all commands (loaded only when invoked)
cp scaffold.md ~/.claude/commands/scaffold.md
cp plan.md ~/.claude/commands/plan.md
cp review.md ~/.claude/commands/review.md
```

> **Already have a global CLAUDE.md?** The install backs it up to `CLAUDE.md.bak`. After installing, merge your custom rules back in: `diff ~/.claude/CLAUDE.md.bak ~/.claude/CLAUDE.md`

Verify it works:

```bash
# Open Claude Code in any directory
claude

# Type /scaffold, /plan, or /review and hit Tab — you should see them autocomplete
```

---

## Quick Start

### 1. Open Claude Code in an empty directory

```bash
mkdir my-new-project && cd my-new-project
claude
```

### 2. Run the scaffold command

```
/scaffold Python 3.12 + FastAPI + PostgreSQL REST API for a bookstore inventory system
```

### 3. Review the plan

Claude will output a directory tree, dependency list, and phased implementation plan. **Don't skip this step.** Review it and give corrections:

```
Plan looks good, but:
- Use SQLAlchemy 2.0 instead of raw SQL
- Add Redis for caching
- Put tests in tests/ not alongside source
Proceed with phase 1.
```

> **Note:** If your prompt is vague, Claude will ask clarifying questions before generating a plan. See [Clarification Behavior](#clarification-behavior) below.

### 4. Let Claude build phase by phase

Claude implements one phase at a time, running build + lint + tests after each. You just review and approve.

### 5. Get your project

Claude finishes with a summary, working app, and initial git commit.

> **`/scaffold` vs `/init`:** Claude Code has a built-in `/init` command that auto-generates a CLAUDE.md by analyzing an existing codebase. Use `/init` when you already have code and want Claude to learn your conventions. Use `/scaffold` when you're generating a new project from scratch — it creates the code AND the CLAUDE.md together.

---

## Usage Patterns

### Full Spec (best results, complex projects)

Provide all the details upfront. More specificity = fewer iterations = less token waste.

```
/scaffold project:

Name: storefront-api
Type: API
Language: Go 1.22
Framework: Chi router
Runtime/Version: Go 1.22
Purpose: REST API for an e-commerce storefront with product catalog and order management

Data layer: PostgreSQL + sqlc
Auth: JWT with refresh tokens
Deploy target: Docker + Fly.io

Core entities: Product, Category, Order, OrderItem, User
Key features:
1. Product CRUD with category filtering and search
2. Shopping cart with session persistence
3. Order placement with inventory validation
4. Admin endpoints for inventory management

Architecture: Clean Architecture (handler → service → repository)
Directory structure: layer-based
Testing: Go test + testify
Linting: golangci-lint
Package manager: Go modules

Constraints:
- No ORM — use sqlc for type-safe SQL
- Structured logging with slog
- Request validation with go-playground/validator
- Docker compose for local dev (API + Postgres + Redis)
- Migrations with golang-migrate

Reference: Look at internal/handler/health.go for handler pattern
```

### Minimal Spec (fast prototypes, familiar stacks)

When you know Claude handles a stack well:

```
/scaffold Next.js 15 + TypeScript + Prisma + PostgreSQL blog with auth, markdown posts, and comments
```

```
/scaffold Rust CLI tool using clap that converts CSV files to JSON with column filtering
```

```
/scaffold Laravel 11 SaaS starter with Stripe billing, team management, and role-based access
```

### Stack-Only Spec (when you just need boilerplate)

```
/scaffold Django 5 + DRF + PostgreSQL API starter
```

```
/scaffold .NET 9 minimal API with EF Core and JWT auth
```

Claude will infer sensible defaults for everything you don't specify.

---

## What Happens Under the Hood

When you run `/scaffold`, Claude follows a 5-step protocol:

```
┌─────────────────────────────────────────────┐
│           SCAFFOLDING PROTOCOL              │
├─────────────────────────────────────────────┤
│                                             │
│  Step 1: CLARIFY   Parse your spec. If too  │
│                    vague, ask questions.     │
│                    If clear, proceed.        │
│                                             │
│  Step 2: PLAN      Output directory tree,   │
│                    deps, phases. Save to     │
│                    Plan.md. STOP and wait    │
│                    for approval.             │
│                                             │
│  Step 3: IMPLEMENT Build one phase at a     │
│                    time, verify each with    │
│                    build + lint + test.      │
│                    Git commit each phase.    │
│                    Roll back on 2 failures.  │
│                                             │
│  Step 4: VERIFY    Full test suite, resolve  │
│                    TODOs, security check,    │
│                    ensure README + CLAUDE.md │
│                    Offer CI/CD generation.   │
│                                             │
│  Step 5: SUMMARY   Quick start commands,    │
│                    file count, next steps,   │
│                    post-scaffold guidance.   │
│                                             │
└─────────────────────────────────────────────┘
```

---

## Customization

### Adding Your Own Defaults

Edit `~/.claude/CLAUDE.md` to add your personal preferences:

```markdown
## Code Style
- Prefer modern language idioms over legacy patterns
- Strong/strict typing when available
+ - Always use 2-space indentation
+ - Prefer early returns over nested conditionals
+ - Comments explain WHY, not WHAT

## Workflow
- Always create a git branch before making changes
+ - Branch naming: feat/[name], fix/[name], chore/[name]
+ - Commit messages follow conventional commits
```

Keep it under 50 lines. Anything longer should go in project-level CLAUDE.md or docs/ files.

### Adding Stack-Specific Commands

These commands are **not included in the kit** — they're examples to show you how to create your own for stacks you use often:

```bash
# React component generator
cat > ~/.claude/commands/component.md << 'EOF'
Create a new React component: $ARGUMENTS

Rules:
- Create [ComponentName]/index.tsx + types.ts
- Use Tailwind for styling
- Add Storybook story
- Add unit test with React Testing Library
- Follow pattern in nearest existing component
EOF

# API endpoint generator
cat > ~/.claude/commands/endpoint.md << 'EOF'
Create a new API endpoint: $ARGUMENTS

Rules:
- Follow existing route pattern in the project
- Add request validation
- Add error handling
- Add unit test
- Update API docs if they exist
EOF
```

Usage:
```
/component UserAvatar with online status indicator and size variants
/endpoint POST /api/orders that validates cart items and creates an order
```

### Permission Allowlists

Reduce approval prompts by pre-approving safe commands. Add to your project's `.claude/settings.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)",
      "Bash(git status:*)",
      "Bash(git commit:*)",
      "Bash(git checkout -b:*)",
      "Bash(mkdir:*)",
      "Bash(cat:*)",
      "Bash(ls:*)",
      "Edit(**)"
    ]
  }
}
```

Then add your stack-specific commands:

| Stack | Add to allow list |
|-------|-------------------|
| Node/JS | `"Bash(npm run *)"`, `"Bash(npx *)"` |
| Python | `"Bash(python -m pytest *)"`, `"Bash(uv run *)"`, `"Bash(ruff *)"` |
| .NET | `"Bash(dotnet build *)"`, `"Bash(dotnet test *)"` |
| Go | `"Bash(go build *)"`, `"Bash(go test *)"` |
| Rust | `"Bash(cargo build *)"`, `"Bash(cargo test *)"` |
| PHP | `"Bash(composer *)"`, `"Bash(php artisan *)"` |
| Java | `"Bash(mvn *)"`, `"Bash(gradle *)"` |

---

## Clarification Behavior

Claude rates your spec on a 1–3 scale and responds accordingly:

### Level 1 — Too Vague (asks 3-5 questions)

If you type something like:

```
/scaffold a web app
```

Claude will respond:

```
I need a few details before scaffolding:

1. What does this app do? (e.g., "task management for teams" not just "web app")
2. Language + framework? (e.g., "Python 3.12 + FastAPI" or "TypeScript + Next.js 15")
3. Data layer? (e.g., "PostgreSQL + Prisma" or "none / in-memory")
4. Auth needed? (e.g., "JWT" / "Google OAuth" / "none")
5. Any hard constraints? (e.g., "must use App Router" / "Docker deploy" / "no ORM")
```

### Level 2 — Partially Clear (asks 1-2 questions)

If you type:

```
/scaffold FastAPI REST API for a bookstore
```

Claude will respond:

```
Got it — a FastAPI bookstore REST API. A couple of quick questions:

1. Data layer? PostgreSQL + SQLAlchemy 2.0 or something else?
2. Auth? JWT or none?

Or say "defaults are fine" and I'll proceed with those.
```

### Level 3 — Clear Enough (proceeds directly to plan)

If you type:

```
/scaffold Go 1.22 + Chi + PostgreSQL + sqlc API for task management with JWT auth
```

Claude proceeds straight to the plan, stating any assumptions:

```
[ASSUMPTIONS: Using Go test + testify, golangci-lint, Docker compose for local dev — override in plan feedback]

## Project Plan: task-api
...
```

### Why This Matters

Asking 2 questions upfront costs ~100 tokens. Guessing wrong and rewriting costs ~2,000+ tokens. The clarification step exists to protect your time and token budget.

---

## Model Selection

Claude Code supports multiple models. Choose based on your scaffolding complexity:

| Model | Best For | Speed | Token Cost | When to Use |
|-------|----------|-------|------------|-------------|
| **Sonnet 4.5** | Standard projects, familiar stacks, quick prototypes | Fast | Lower | You've scaffolded this type before, stack is well-known, < 4 phases |
| **Opus 4.6** | Complex architecture, unfamiliar stacks, monorepos | Slower | Higher | Clean Architecture, microservices, multi-package monorepos, novel patterns |

**Rules of thumb:**

- **Default to Sonnet** for most scaffolding — it handles standard project structures well and iterates faster
- **Switch to Opus** when you see Claude making architectural mistakes with Sonnet, or when the project requires complex decisions (dependency injection patterns, event-driven architecture, multi-service communication)
- **Use Sonnet for individual phases** even if you planned with Opus — once the plan is approved, execution is more mechanical

Switch models mid-session:
```
/model sonnet
/model opus
```

---

## Token Optimization Tips

### Do This

- **Pin versions** in your spec — `Python 3.12 + FastAPI 0.115` not just `Python + FastAPI`
- **Use constraints** for decisions Claude would guess wrong
- **Reference existing files** — `Follow pattern in src/routes/users.go` beats explaining the pattern
- **Run `/clear` every 3-4 major interactions** during long scaffolding sessions
- **After `/clear`, re-anchor:** `Read CLAUDE.md and continue with Phase 3`

### Avoid This

- Vague prompts — "make it nice" or "follow best practices" wastes tokens
- @-importing large files — reference by path instead, Claude will read when needed
- Asking Claude to "add tests" without specifying what to assert
- Letting context grow beyond 5 phases without clearing

### Token Cost Comparison

| Approach | Avg. Tokens | Result Quality |
|----------|-------------|----------------|
| Vague prompt, no plan, fix as you go | ~50,000 | Inconsistent |
| Structured spec, no plan review | ~25,000 | Good |
| **Structured spec + plan review + phased build** | **~15,000** | **Consistent** |

The structured approach uses fewer tokens AND produces better output because corrections happen at the plan level (cheap) instead of the code level (expensive).

---

## Troubleshooting

### "Claude isn't using my scaffold command"

Make sure the file is in the right location:
```bash
ls ~/.claude/commands/scaffold.md
```
Restart Claude Code after adding new commands.

### "Claude skipped the plan step and started coding"

Add this to your prompt:
```
Plan first. Do NOT write any code until I approve the plan.
```

### "Output drifts from conventions after many phases"

Context is overflowing. Run `/clear` and re-anchor:
```
Read CLAUDE.md and the Plan.md file. Continue with Phase [N].
```

### "Claude generates outdated framework patterns"

You didn't pin versions. Always specify:
```
Next.js 15 (App Router)    ← good
Next.js                     ← bad, might use Pages Router patterns
```

### "Build fails after scaffolding"

Check if Claude skipped the verification step. Run:
```
Run build + lint + test. Fix all errors before proceeding.
```

### "CLAUDE.md is too generic after scaffolding"

Tell Claude to improve it based on what it just built:
```
Update CLAUDE.md to reflect the actual conventions, commands, and patterns
in this project. Be specific — include actual file paths and command examples.
```

### "Claude is stuck in a fix loop (fix → break → fix → break)"

The scaffold protocol has a 2-attempt limit. If it triggers, Claude will stop and offer to roll back. If it doesn't trigger automatically:
```
Stop. Don't fix it again. Diagnose the root cause and tell me what's wrong. 
Then offer to roll back with git reset and retry with a different approach.
```

---

## Scaffolding Into Existing Projects

You can run `/scaffold` in a directory with existing code. Claude will:

1. Detect the existing project structure and conventions
2. Show what will be added vs. modified (with a diff preview)
3. Integrate new code alongside existing patterns — not overwrite them
4. Require your approval before changing any existing files

Example:
```
/scaffold Add a REST API layer with JWT auth to this existing React frontend
```

Claude will read your current structure, propose additions that fit your existing conventions, and ask before touching anything that already exists.

**Important:** Make sure your working tree is clean (`git status`) before scaffolding into an existing project. Claude will remind you if it isn't.

---

## CI/CD Generation

During the verify step, Claude will offer to generate CI configuration if relevant:

```
I can also generate a CI pipeline for this project. Want me to add:
- GitHub Actions workflow (build + lint + test on PR)
- Dockerfile + docker-compose for local dev
- Pre-commit hooks config

Say "add CI" or skip.
```

You can also request it explicitly:
```
/scaffold Add GitHub Actions CI + Docker to this project
```

---

## After Scaffolding — What Next?

The scaffold gives you a working foundation. Here's how to keep building efficiently:

### Add a Feature
```
Plan how to add [feature]. Don't code yet.
```
Review the plan, then approve. Same plan → implement → test cycle as scaffolding.

### Fix Something Claude Got Wrong
Be specific and point to the file:
```
The auth middleware doesn't check token expiry. Fix src/middleware/auth.[ext]
```

### Improve CLAUDE.md Over Time
After a few sessions, tell Claude to refine it:
```
Update CLAUDE.md based on patterns you've seen me correct
```

### Useful Commands for Ongoing Work

| Command | What It Does |
|---------|-------------|
| `/clear` | Reset context when conversation gets long |
| `#` key | Add a quick note to CLAUDE.md mid-session |
| `/compact` | Summarize conversation to save context |
| `/plan` | Create an implementation plan for a feature or change |
| `/review` | Review code for bugs, security, performance, and style |
| `/init` | Auto-generate CLAUDE.md from existing codebase (built-in) |

---

## Automated / CI Scaffolding

For fully automated scaffolding (e.g., in a CI pipeline or script), you can bypass permission prompts:

```bash
claude --dangerously-skip-permissions -p "/scaffold Go 1.22 + Chi REST API for task management"
```

> **Warning:** This skips ALL permission checks. Only use in isolated/sandboxed environments (containers, CI runners). Never on your local machine with access to sensitive files.

For a safer alternative, use `/sandbox` which provides OS-level isolation while still allowing Claude to work freely within defined boundaries.

---

## Recommended MCP Servers

Extend Claude Code's capabilities during and after scaffolding:

| MCP Server | Purpose | When to Use |
|-----------|---------|-------------|
| **Playwright / Chrome** | Browser testing, visual debugging, console log access | Frontend projects, full-stack apps |
| **PostgreSQL / MySQL** | Direct DB queries, schema inspection | Data-heavy projects, migration verification |
| **GitHub** | Issue triage, PR creation, code review | Team workflows, CI integration |
| **Figma** | Design-to-code, extract specs and assets | UI-heavy projects |
| **Notion / Linear** | Pull requirements, sync tasks | Project management integration |

Configure via:
```bash
claude mcp add [server-name] -- [connection-command]
```

Example — add a PostgreSQL server for direct DB access during scaffolding:
```bash
claude mcp add postgres -- npx @anthropic-ai/mcp-server-postgres postgresql://localhost:5432/mydb
```

---

## File Structure After Setup

```
~/.claude/
├── CLAUDE.md                  ← global defaults (loaded every session)
├── CLAUDE.md.bak              ← backup of your previous CLAUDE.md (if any)
└── commands/
    ├── scaffold.md            ← project scaffolding protocol (/scaffold)
    ├── plan.md                ← standalone planning command (/plan)
    └── review.md              ← code review command (/review)

your-project/
├── CLAUDE.md                  ← project-specific (generated by /scaffold)
├── Plan.md                    ← implementation plan (generated, clean up after)
├── .claude/
│   ├── settings.json          ← permission allowlists (optional)
│   ├── hooks.json             ← deterministic quality checks (optional)
│   └── commands/              ← project-specific commands (optional)
│       ├── backend.md
│       └── frontend.md
├── docs/                      ← progressive disclosure docs (optional)
│   ├── architecture.md
│   ├── api-patterns.md
│   └── testing.md
├── README.md
├── .gitignore
└── [your source code]
```

---

## Contributing

Claude Architect is a living framework. Improve it by:

1. **Refining `~/.claude/CLAUDE.md`** — add conventions Claude consistently gets wrong
2. **Updating `scaffold.md`** — add constraint defaults for project types you use
3. **Creating stack-specific commands** — share reusable commands with your team
4. **Reporting patterns** — if Claude consistently fails at something, add it as a constraint

---

## License

MIT — use it, fork it, share it.
