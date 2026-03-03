---
allowed-tools: Bash(cat:*), Bash(ls:*), Bash(find:*), Bash(grep:*), Bash(git log:*), Bash(git diff:*), Bash(git status:*), Bash(npm audit:*), Bash(pip audit:*), Bash(cargo audit:*), Bash(bundle audit:*)
---

Security audit: $ARGUMENTS

# SECURITY AUDIT PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Scope:** full project | specific module | auth flow | API layer | "quick scan"
- **Focus:** OWASP top 10 | auth/authz | input validation | secrets | dependencies | "all"

If $ARGUMENTS is vague ("check security"), default to full project OWASP scan.

## STEP 2: ANALYZE

1. Read CLAUDE.md — check existing security conventions
2. Load matched framework reference file — check Pitfalls for known security issues
3. Scan project structure: auth middleware, route handlers, DB queries, env files, config

## STEP 3: AUDIT CHECKLIST

### A. Injection (SQL, NoSQL, Command, XSS)
- [ ] DB queries use parameterized queries / ORM — never string concatenation
- [ ] User input sanitized before rendering (XSS): HTML escaped, no dangerouslySetInnerHTML with user data
- [ ] No `eval()`, `exec()`, `child_process.exec()` with user input
- [ ] Template engines auto-escape by default
- [ ] Search: `grep -r "exec\|eval\|raw\|innerHTML\|dangerously" --include="*.{ts,js,py,rb,go,rs,java,php}"`

### B. Authentication
- [ ] Passwords hashed with bcrypt/argon2/scrypt — never MD5/SHA
- [ ] JWT: tokens expire, refresh token rotation, secret not hardcoded
- [ ] Session: secure + httpOnly + sameSite cookies
- [ ] Rate limiting on login/signup/password-reset endpoints
- [ ] No auth bypass: all protected routes check auth middleware

### C. Authorization
- [ ] Role/permission checks on every protected endpoint (not just frontend)
- [ ] No IDOR: users can only access their own resources (check ownership in queries)
- [ ] Admin routes separated and double-checked
- [ ] API keys/tokens scoped to minimum required permissions

### D. Secrets & Configuration
- [ ] `.env` in `.gitignore` — never committed
- [ ] No hardcoded secrets in source code: `grep -r "password\|secret\|api_key\|token" --include="*.{ts,js,py,rb,go,rs,java,php}" | grep -v test | grep -v node_modules`
- [ ] `.env.example` exists with placeholder values
- [ ] Production config: HTTPS enforced, debug mode off, verbose errors disabled
- [ ] CORS: allowed origins explicitly listed, not `*` in production

### E. Input Validation
- [ ] All API inputs validated (request body, query params, path params, headers)
- [ ] File uploads: type validation, size limits, no path traversal
- [ ] Numeric inputs: range-checked, no integer overflow
- [ ] String inputs: length-limited, sanitized for special characters

### F. Dependencies
- [ ] Run `npm audit` / `pip audit` / `cargo audit` / `bundle audit` (whichever applies)
- [ ] No known critical/high vulnerabilities in production dependencies
- [ ] Lock file present and committed (package-lock.json, poetry.lock, etc.)

### G. Data Exposure
- [ ] API responses don't leak: passwords, tokens, internal IDs, stack traces, DB schemas
- [ ] Error responses in production: generic messages, no stack traces
- [ ] Logging: no PII, passwords, or tokens in logs
- [ ] Database: sensitive fields encrypted at rest where required

### H. Framework-Specific
Check the loaded framework reference's Pitfalls section for known security gotchas:
- **Next.js:** Server Actions validate input, no client-exposed secrets in server components
- **Django:** CSRF middleware enabled, SECRET_KEY not in code
- **Rails:** strong params on every controller, CSRF protection enabled
- **Express:** helmet middleware, no `trust proxy` without reverse proxy
- **FastAPI:** Depends() for auth on every route, Pydantic validation
- **Go:** context-based timeouts, no raw SQL concatenation

## STEP 4: REPORT

```
## Security Audit: [project name]

### Critical (fix immediately)
- [FINDING] — [file:line] — [what's wrong] — [fix]

### High (fix before deploy)
- [FINDING] — [file:line] — [what's wrong] — [fix]

### Medium (fix soon)
- [FINDING] — [file:line] — [what's wrong] — [fix]

### Low / Informational
- [FINDING] — [recommendation]

### Passed Checks
- [list of checks that passed cleanly]

### Dependency Audit
[output of npm audit / pip audit / etc.]

### Next Steps
- Fix critical/high findings immediately
- /refactor — if fixes require structural changes
- Schedule regular audits (monthly or per-release)
```

## SECURITY RULES
- **Read-only audit** — this command reports findings, it does NOT modify code
- **No false confidence** — if you can't verify a check, say "UNABLE TO VERIFY" not "passed"
- **Severity matters** — Critical = exploitable now, High = exploitable with effort, Medium = defense-in-depth, Low = best practice
- **Framework pitfalls first** — 60% of security issues are known framework gotchas
- **Secrets are always critical** — any hardcoded secret or committed .env is severity: Critical
- **Defense in depth** — validate on client AND server. Never trust frontend-only checks
- **Assume breach** — check what happens if auth is bypassed. Are there secondary checks?
- **Dependencies count** — a vulnerable dependency is your vulnerability
