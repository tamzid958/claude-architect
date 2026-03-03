# Claude Architect

A plug-and-play framework for generating projects with Claude Code CLI — optimized for speed, token efficiency, and consistent output across any language or framework.

**Version:** 3.0.0 | **Last Updated:** March 2026 | **License:** MIT

### Changelog

- **3.0.0** — 70% token reduction via delta-only framework files, merged similar frameworks (Express+Hono, Gin+Echo+Fiber, Actix+Axum+Rocket, React Native+Expo), inheritance model (global → _base → framework), no pinned versions ("latest stable" everywhere), compressed protocol files with error recovery and framework pitfall integration. 32 framework files across 12 ecosystems.
- **2.0.0** — Full framework knowledge base (47 files). Framework-specific detection, conventions, and CLAUDE.md templates. Senior architect personas. Clarification-first protocol. Model guidance.
- **1.0.0** — Initial release. Scaffold, onboard, plan, review commands. Global CLAUDE.md.

---

## What's Included

| File / Directory | Location | Purpose |
|------|----------|---------|
| `global-CLAUDE.md` | `~/.claude/CLAUDE.md` | Universal defaults: clarification-first, model guidance, quality gates |
| `scaffold.md` | `~/.claude/commands/scaffold.md` | Full scaffolding protocol (`/scaffold`) |
| `onboard.md` | `~/.claude/commands/onboard.md` | Onboard existing projects (`/onboard`) |
| `plan.md` | `~/.claude/commands/plan.md` | Feature/change planning (`/plan`) |
| `review.md` | `~/.claude/commands/review.md` | Code review for PRs/branches/files (`/review`) |
| `frameworks/` | `~/.claude/commands/frameworks/` | **32 framework files** + 13 base files + detection matrix |

### Inheritance Model

```
global-CLAUDE.md          ← universal rules (loaded every session)
  └─ frameworks/{lang}/_base.md   ← language defaults (detection, commands, .gitignore, pitfalls)
       └─ frameworks/{lang}/{framework}.md  ← delta-only (only what differs from _base)
```

Framework files inherit from their _base.md and only contain framework-specific conventions, commands, and pitfalls. This eliminates redundancy and keeps token costs low.

### Supported Frameworks (32 files, 12 ecosystems)

| Language | Frameworks |
|----------|-----------|
| **TypeScript/JS** | Next.js, React, Vue, Nuxt, Svelte, SvelteKit, NestJS, Astro, Remix, Express+Hono (merged) |
| **Python** | Django, FastAPI, Flask, Scrapy |
| **Go** | Gin+Echo+Fiber (merged), stdlib |
| **Rust** | Actix+Axum+Rocket (merged), Tauri |
| **C#/.NET** | ASP.NET Core, Blazor, .NET MAUI |
| **Java** | Spring Boot, Quarkus |
| **Kotlin** | Ktor |
| **PHP** | Laravel, Symfony |
| **Ruby** | Rails, Sinatra |
| **Swift** | SwiftUI, Vapor |
| **Mobile** | React Native+Expo (merged), Flutter |
| **C/C++** | CMake, vanilla Make |

Each framework file: senior architect persona, detection signals, commands, conventions, testing, CLAUDE.md Convention Block, and pitfalls. All versions use "latest stable" — detected at runtime from project config files.

---

## Installation

```bash
# 1. Back up existing global CLAUDE.md
[ -f ~/.claude/CLAUDE.md ] && cp ~/.claude/CLAUDE.md ~/.claude/CLAUDE.md.bak

# 2. Copy global defaults (loaded every session)
cp global-CLAUDE.md ~/.claude/CLAUDE.md

# 3. Create commands directory
mkdir -p ~/.claude/commands

# 4. Copy commands (loaded when invoked)
cp scaffold.md onboard.md plan.md review.md ~/.claude/commands/

# 5. Copy framework knowledge base
cp -r frameworks/ ~/.claude/commands/frameworks/
```

Verify:
```bash
claude
# Type /scaffold, /onboard, /plan, or /review and hit Tab
```

---

## Quick Start

```bash
mkdir my-project && cd my-project && claude
```

```
/scaffold Python + FastAPI + PostgreSQL REST API for a bookstore inventory system
```

Claude will: clarify (if needed) → plan → wait for approval → implement phase-by-phase → verify → summarize.

> `/scaffold` = new project | `/onboard` = existing project (deep analysis) | `/init` = quick CLAUDE.md (built-in)

---

## Usage Patterns

### Full Spec (best results)
```
/scaffold project:
Name: storefront-api
Type: API
Language: Go
Framework: Chi router
Purpose: REST API for e-commerce with product catalog and orders
Data layer: PostgreSQL + sqlc
Auth: JWT with refresh tokens
Core entities: Product, Category, Order, User
Constraints: No ORM, structured logging with slog, Docker compose
```

### Minimal Spec (fast prototypes)
```
/scaffold Next.js + Prisma + PostgreSQL blog with auth and markdown posts
/scaffold Rust CLI using clap that converts CSV to JSON with column filtering
/scaffold Laravel SaaS starter with Stripe billing and team management
```

### Stack-Only (just boilerplate)
```
/scaffold Django + DRF + PostgreSQL API starter
/scaffold .NET minimal API with EF Core and JWT auth
```

---

## Clarification Behavior

Claude rates specs 1-3:

- **Level 1 (too vague)** — "a web app" → asks 3-5 questions before proceeding
- **Level 2 (partial)** — "FastAPI bookstore API" → asks 1-2 missing fields with sensible defaults
- **Level 3 (clear)** — "Go + Chi + PostgreSQL + JWT task API" → proceeds to plan, states assumptions

**2 questions upfront ≈ 100 tokens. Guessing wrong ≈ 2,000+ tokens of rework.**

---

## Model Selection

| Phase | Model | Why |
|-------|-------|-----|
| Planning/Analysis (`/plan`, `/onboard`, `/review`) | **Opus** | Deeper reasoning, better architecture |
| Execution (`/scaffold` phases) | **Sonnet** | Faster, efficient for known patterns |
| Complex debugging | **Opus** | Better root cause analysis |
| Straightforward features | **Sonnet** | Speed advantage |

Switch mid-session: `/model sonnet` or `/model opus`

---

## Token Optimization

**Do:** Use constraints, reference existing files by path, `/clear` every 3-4 interactions, re-anchor with `Read CLAUDE.md and Plan.md`
**Don't:** Vague prompts, @-import large files, let context grow past 5 phases

| Approach | Tokens | Quality |
|----------|--------|---------|
| Vague, no plan, fix as you go | ~50k | Inconsistent |
| Structured spec, no plan review | ~25k | Good |
| **Structured spec + plan review + phased** | **~15k** | **Consistent** |

---

## Customization

### Personal Defaults
Edit `~/.claude/CLAUDE.md` (keep under 50 lines).

### Stack-Specific Commands
Create custom commands in `~/.claude/commands/`:
```bash
cat > ~/.claude/commands/component.md << 'EOF'
Create a new React component: $ARGUMENTS
Rules: ComponentName/index.tsx + types.ts, Tailwind, Storybook story, unit test
EOF
```

### Permission Allowlists
Add to `.claude/settings.json`:
```json
{
  "permissions": {
    "allow": [
      "Bash(git add:*)", "Bash(git status:*)", "Bash(git commit:*)",
      "Bash(npm run *)", "Bash(npx *)", "Edit(**)"
    ]
  }
}
```

---

## Onboarding Existing Projects

```
cd your-project && claude
/onboard
```

Claude will: detect stack → analyze structure + patterns → report → generate CLAUDE.md + docs/ → offer hooks/permissions. **Never modifies source code.**

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Command not found | Verify `ls ~/.claude/commands/scaffold.md`, restart Claude |
| Skipped plan step | Add: "Plan first. Do NOT code until I approve." |
| Drift after many phases | `/clear` then: "Read CLAUDE.md and Plan.md. Continue Phase N." |
| Outdated patterns | Be specific about framework version in your spec |
| Build fails | Run: "Build + lint + test. Fix all errors." |
| Fix loop | "Stop. Diagnose root cause. Offer rollback." |

---

## File Structure

```
~/.claude/
├── CLAUDE.md                     ← global defaults
└── commands/
    ├── scaffold.md onboard.md plan.md review.md
    └── frameworks/
        ├── _index.md             ← detection matrix
        ├── typescript/           ← _base + nextjs, react, vue, nuxt, svelte, sveltekit, nestjs, astro, remix, api
        ├── python/               ← _base + django, fastapi, flask, scrapy
        ├── go/                   ← _base + web (gin/echo/fiber)
        ├── rust/                 ← _base + web (actix/axum/rocket), tauri
        ├── dotnet/               ← _base + aspnet-core, blazor, maui
        ├── java/                 ← _base + spring-boot, quarkus
        ├── kotlin/               ← _base + ktor
        ├── php/                  ← _base + laravel, symfony
        ├── ruby/                 ← _base + rails, sinatra
        ├── swift/                ← _base + swiftui, vapor
        ├── mobile/               ← _base + react-native-expo, flutter
        └── cpp/                  ← _base + cmake
```

---

## License

MIT — use it, fork it, share it.
