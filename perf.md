---
allowed-tools: Bash(*), Edit(**)
---

Optimize performance: $ARGUMENTS

# PERFORMANCE OPTIMIZATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Target:** specific page/endpoint/function | bundle size | DB queries | "general audit"
- **Symptom:** slow load | slow API | high memory | large bundle | "unknown — just slow"
- **Metric:** target response time, bundle size, LCP, TTFB (if specified)

If $ARGUMENTS is vague ("make it faster"), ask:
```
1. What's slow? (page load / API response / build time / "everything")
2. Where? (specific route, endpoint, or component)
3. Target? (e.g., < 200ms API, < 1s page load, < 200kb bundle)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md — check existing performance conventions
2. Load matched framework reference file — check framework-specific perf patterns
3. Profile based on target:

### Frontend Performance
- Bundle size: `npx vite-bundle-analyzer` / `npx @next/bundle-analyzer` / framework equivalent
- Unused code: `npx knip` or check tree-shaking effectiveness
- Heavy deps: check `node_modules` sizes of top imports
- Render performance: identify unnecessary re-renders, missing memoization
- Asset loading: images (unoptimized), fonts (FOUT/FOIT), third-party scripts

### API/Backend Performance
- Slow queries: read DB access patterns, check for N+1 queries, missing indexes
- Middleware overhead: count middleware chain, identify unnecessary per-request work
- Serialization: large response payloads, missing pagination
- Caching: identify cacheable data with no caching layer
- Connection pooling: DB/Redis connection management

### Build Performance
- Build time: identify slow plugins, unoptimized config
- TypeScript: check for expensive type computations
- Dev server: HMR speed, cold start time

**Output analysis:**
```
## Performance Analysis: [target]

### Findings (ranked by impact)
1. [issue] — impact: [high/medium/low] — effort: [low/medium/high]
2. [issue] — impact: [high/medium/low] — effort: [low/medium/high]
3. [issue] — impact: [high/medium/low] — effort: [low/medium/high]

### Metrics (baseline)
[current measurements — response time, bundle size, etc.]

### Optimization Plan
Phase 1 (quick wins): [changes with high impact + low effort]
Phase 2 (medium effort): [structural improvements]
Phase 3 (if needed): [architectural changes]
```

STOP and wait for approval.

## STEP 3: EXECUTE (after approval)

```bash
git checkout -b perf/[description]
```

Per optimization:
1. Apply change
2. Measure improvement (before/after with same method)
3. Run tests — performance optimization must not break functionality
4. Commit with measurement: `git commit -m "perf: [what] — [metric improvement]"`

### Common Optimizations by Category

**Frontend:**
- Code splitting: dynamic imports for routes/heavy components
- Image optimization: next/image, sharp, WebP/AVIF format
- Lazy loading: below-fold components, offscreen images
- Memoization: React.memo, useMemo, computed (Vue), derived (Svelte)
- Bundle reduction: replace heavy libs (moment→dayjs, lodash→individual imports)

**Backend:**
- N+1 queries: eager loading / dataloaders / joins
- Missing indexes: add indexes for WHERE/ORDER BY/JOIN columns
- Response pagination: cursor or offset pagination for list endpoints
- Caching: response cache, query cache, computed value cache
- Connection pooling: proper pool size for DB connections

**General:**
- Compression: gzip/brotli for responses
- CDN: static assets on CDN
- Prefetching: dns-prefetch, preconnect for external origins

## STEP 4: VERIFY

1. Measure after ALL changes applied (not just individual)
2. Tests pass — no regressions
3. Build size comparison: before vs after
4. Response time comparison: before vs after (if backend)
5. No premature optimization introduced (readable code > marginal gains)

## STEP 5: OUTPUT SUMMARY

```
## Performance Optimized: [target]

### Results
| Metric | Before | After | Improvement |
|--------|--------|-------|------------|
| [metric] | [value] | [value] | [%] |

### Changes Applied
- [change 1] — [impact]
- [change 2] — [impact]

### Not Worth Optimizing (analyzed, skipped)
- [thing] — marginal gain, high complexity

### Verified
All tests pass | Build clean | Metrics improved

### Next Steps
- Monitor in production (performance can differ from dev)
- /test — verify no regressions under load
- /review — check for readability after optimizations
```

## PERFORMANCE RULES
- **Measure first** — no optimization without a baseline measurement
- **Profile, don't guess** — use tools to find actual bottlenecks, not assumed ones
- **High impact first** — fix the biggest bottleneck first. 80/20 rule applies
- **Don't sacrifice readability** — unreadable "fast" code is tech debt. Measure the actual gain
- **Quick wins before architecture** — code splitting before rewriting, indexing before caching layers
- **Test after every change** — optimizations that break features aren't optimizations
- **Commit with metrics** — every perf commit message includes the measured improvement
- **Know when to stop** — diminishing returns are real. 200ms → 150ms matters less than 3s → 500ms
