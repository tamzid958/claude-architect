---
allowed-tools: Bash(*), Edit(**)
---

Manage dependencies: $ARGUMENTS

# DEPENDENCY MANAGEMENT PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Action:** audit | upgrade | add | remove | dedupe | "health check"
- **Scope:** all deps | specific package(s) | major upgrades only | security-only
- **Constraints:** no breaking changes | specific version target | framework compatibility

If $ARGUMENTS is vague ("update deps"), default to health check (audit + list outdated + recommend).

## STEP 2: ANALYZE

1. Read CLAUDE.md — check dependency conventions, version constraints
2. Load matched framework reference file — check for framework-specific dep requirements
3. Detect package manager and read lock file:
   - **Node:** package.json + (npm/yarn/pnpm/bun)
   - **Python:** pyproject.toml / requirements.txt + (pip/poetry/uv)
   - **Go:** go.mod + go.sum
   - **Rust:** Cargo.toml + Cargo.lock
   - **Ruby:** Gemfile + Gemfile.lock
   - **Java/Kotlin:** build.gradle / pom.xml
   - **PHP:** composer.json + composer.lock
   - **.NET:** *.csproj / Directory.Packages.props

4. Run diagnostics:
   - **Outdated:** `npm outdated` / `pip list --outdated` / `go list -m -u all` / `cargo outdated`
   - **Vulnerabilities:** `npm audit` / `pip audit` / `cargo audit` / `bundle audit`
   - **Unused:** check imports vs installed (if tooling available)
   - **Duplicates:** `npm ls --all | grep "deduped"` or equivalent

## STEP 3: PLAN

```
## Dependency Plan: [project name]

### Current State
Total deps: [N] (prod: [N], dev: [N])
Outdated: [N] (major: [N], minor: [N], patch: [N])
Vulnerabilities: [N] (critical: [N], high: [N], moderate: [N])
Unused: [list or "none detected"]

### Recommended Actions
Priority 1 (security): [package] [current] → [target] — fixes [CVE/advisory]
Priority 2 (major upgrades): [package] [current] → [target] — [breaking changes summary]
Priority 3 (minor/patch): [N] packages — safe to batch update
Priority 4 (cleanup): remove [unused packages]

### Risk Assessment
- [package upgrade] — breaking: [yes/no] — migration needed: [yes/no]
- Framework compatibility: [confirmed/needs testing]
```

STOP and wait for approval.

## STEP 4: EXECUTE (after approval)

```bash
git checkout -b deps/[description]
```

Upgrade order (safest first):
1. **Patch updates** — batch all, run tests
2. **Minor updates** — batch compatible ones, run tests
3. **Major updates** — one at a time:
   a. Upgrade package
   b. Read changelog/migration guide for breaking changes
   c. Update code for breaking changes
   d. Run build + lint + tests
   e. Commit: `git commit -m "deps: upgrade [package] to [version]"`
4. **Security fixes** — apply regardless of semver (patch audit findings)
5. **Remove unused** — delete + verify build still passes

**Critical rule:** Run full test suite after EVERY major upgrade. If tests fail, fix before continuing — never batch major upgrades.

**Error Recovery:** If upgrade breaks the build after 2 fix attempts:
1. STOP
2. `git checkout -- [lock file] [manifest]` to revert that package
3. Offer: **A)** skip this upgrade **B)** try alternative version **C)** user decides

## STEP 5: VERIFY

1. Full build passes — zero warnings
2. Full test suite passes
3. Lock file updated and committed
4. No unused dependencies remaining
5. `npm audit` / equivalent shows 0 critical/high vulnerabilities

## STEP 6: OUTPUT SUMMARY

```
## Dependencies Updated: [project name]

### Changes
- Upgraded: [N] packages ([list major upgrades])
- Removed: [N] unused packages
- Security fixes: [N] vulnerabilities resolved

### Before → After
Outdated: [N] → [N]
Vulnerabilities: [N] → [N]

### Breaking Changes Applied
- [package]: [what changed] — [how code was updated]

### Verified
All tests pass | Build clean | 0 critical vulnerabilities

### Next Steps
- /test — verify edge cases after upgrades
- /secure — full security re-audit
- Set up Dependabot/Renovate for automated updates
```

## DEPENDENCY RULES
- **Security first** — critical/high vulnerabilities are always priority 1
- **One major at a time** — never batch major version upgrades
- **Read changelogs** — major upgrades need migration awareness, not blind bumps
- **Lock files are sacred** — always commit updated lock files
- **Test after every change** — upgrades are code changes. Treat them like code changes
- **Don't remove cautiously** — if unsure whether a dep is used, check imports before removing
- **Framework compatibility** — check framework docs for supported dep versions before upgrading
- **Pin what matters** — production deps should have version constraints, not floating `*`
