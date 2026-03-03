---
allowed-tools: Bash(*), Edit(**)
---

Generate deployment config for: $ARGUMENTS

# DEPLOYMENT PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Target:** Docker | CI/CD | Cloud (AWS/GCP/Vercel/Fly/Railway) | Kubernetes | "all"
- **Platform:** GitHub Actions | GitLab CI | Bitbucket Pipelines
- **Environment:** production | staging | both
- **Constraints:** specific cloud provider, budget, region, existing infra

If $ARGUMENTS is vague ("deploy this"), ask:
```
1. Deploy where? (Docker / Vercel / AWS / Fly.io / self-hosted)
2. CI/CD? (GitHub Actions / GitLab CI / none)
3. Environments? (just prod / staging + prod)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md + detect stack
2. Load matched framework reference file — check for framework-specific deploy patterns
3. Check existing deploy config: Dockerfile, docker-compose.yml, .github/workflows/, fly.toml, vercel.json, etc.
4. Identify:
   - Build command + output (static files, binary, container)
   - Runtime dependencies (DB, Redis, storage, queues)
   - Environment variables needed
   - Port configuration
   - Health check endpoint (if API/web)

**Output analysis:**
```
## Deploy Plan: [project name]

### Stack
App: [framework] | Build: [command] | Output: [type]
Runtime deps: [DB, cache, etc.]
Env vars: [list — no values, just names]

### Configs to Generate
- [Dockerfile / docker-compose.yml]
- [.github/workflows/deploy.yml]
- [platform-specific: fly.toml / vercel.json / etc.]
- [.env.example — if not exists]
```

STOP and wait for approval.

## STEP 3: GENERATE

### Dockerfile (if applicable)

Framework-aware patterns:
- **Node.js (Next.js/Nuxt/Remix):** multi-stage build, `standalone` output mode, copy only production deps
- **Python (Django/FastAPI/Flask):** slim base, gunicorn/uvicorn, non-root user
- **Go:** scratch/distroless final image, static binary
- **Rust:** cargo-chef for dependency caching, scratch final image
- **.NET:** SDK build stage, runtime-only final image
- **Ruby (Rails):** precompile assets, puma server
- **Java (Spring Boot):** layered JARs, JRE-only final image

**Every Dockerfile must:**
- Multi-stage build (build deps ≠ runtime deps)
- Non-root user in production
- .dockerignore present (node_modules, .git, .env, build artifacts)
- Health check instruction
- No secrets baked into image

### CI/CD Pipeline (if applicable)

```
Trigger: push to main (deploy) | PR (test only)
Steps:
1. Checkout + cache dependencies
2. Install dependencies
3. Lint + typecheck
4. Test (with services if needed: DB, Redis)
5. Build
6. Deploy (main branch only)
```

**Every pipeline must:**
- Cache dependencies (node_modules, pip cache, go mod cache)
- Run tests before deploy — never skip
- Use secrets for credentials — never hardcode
- Pin action versions (actions/checkout@v4, not @latest)
- Fail fast — stop on first error

### Docker Compose (if applicable)

For local development with services:
- App + DB + cache as services
- Named volumes for data persistence
- Health checks with depends_on conditions
- .env file for configuration

## STEP 4: VERIFY

1. Docker: `docker build -t [name] . && docker run --rm -p [port]:[port] [name]` — starts successfully
2. Docker Compose: `docker compose up --build` — all services healthy
3. CI/CD: validate syntax (`actionlint` for GitHub Actions if available)
4. Security: no secrets in files, .env.example has placeholder values only, .dockerignore present
5. Commit deploy configs

## STEP 5: OUTPUT SUMMARY

```
## Deploy Config Generated: [project name]

### Files Created
- [file 1] — [what it does]
- [file 2] — [what it does]

### To Deploy
[2-4 commands to deploy]

### Environment Variables
Copy .env.example → .env and fill in:
- [VAR_1] — [what it's for]
- [VAR_2] — [what it's for]

### Next Steps
- Set secrets in [CI/CD platform]
- Configure [DNS / domain / SSL]
- /review — verify deploy config
```

## DEPLOY RULES
- **Never commit secrets** — .env in .gitignore, secrets in CI/CD platform
- **Multi-stage Docker builds** — keep images small, no build tools in production
- **Test before deploy** — CI pipeline must run tests. No exceptions
- **Non-root in production** — containers run as unprivileged user
- **.env.example always** — document every required env var with placeholder values
- **Framework-aware** — use framework's recommended production setup (standalone output, gunicorn, etc.)
- **Cache aggressively** — dependency caching in CI saves minutes per run
- **Health checks** — every deployed service needs a health endpoint
