---
allowed-tools: Bash(*), Edit(**)
---

Generate UI component(s) for: $ARGUMENTS

# COMPONENT GENERATION PROTOCOL

## STEP 1: PARSE & CLARIFY

Extract from $ARGUMENTS:
- **Component:** name + purpose (e.g., "DataTable with sorting and pagination")
- **Variants:** states/variants needed (loading, empty, error, disabled)
- **Data:** props/inputs it receives, events/callbacks it emits
- **Scope:** single component | component set (e.g., "form components")

If $ARGUMENTS is vague ("make a card component"), ask:
```
1. What data does it display/accept? (props shape)
2. Interactive? (clickable, editable, expandable)
3. Variants? (loading state, empty state, error state)
```

## STEP 2: ANALYZE

1. Read CLAUDE.md — check component conventions, styling approach, file structure
2. Load matched framework reference file — check component patterns
3. Read existing components — match patterns exactly:
   - File structure (flat vs directory per component)
   - Naming (PascalCase, kebab-case for files)
   - Styling approach (Tailwind, CSS modules, styled-components, etc.)
   - State management patterns
   - Test patterns (testing-library, storybook, etc.)
4. Read design system/theme if present (colors, spacing, tokens)

**Output plan:**
```
## Component Plan: [name]

### Stack
Framework: [React/Vue/Svelte/etc.] | Styling: [Tailwind/CSS modules/etc.]
Pattern: [existing component structure]

### Props/Interface
[prop: type — description]
...

### States
- Default | Loading | Empty | Error | [custom]

### Files to Create
- [component file] — component implementation
- [types file] — prop types (if separate)
- [style file] — styles (if not Tailwind/inline)
- [test file] — component tests
- [story file] — storybook story (if project uses storybook)
```

STOP and wait for approval.

## STEP 3: GENERATE

### File Order
1. **Types** — props interface, variant types, event types
2. **Component** — implementation with all states
3. **Styles** — if separate file needed
4. **Tests** — render, props, interactions, states
5. **Story** — if storybook exists in project

### Framework Patterns

- **React:** functional component, forwardRef if needed, memo if expensive renders
- **Vue 3:** `<script setup>` with defineProps/defineEmits, composables for logic
- **Svelte:** props via `export let`, events via createEventDispatcher or callback props
- **SvelteKit:** +page.svelte for pages, $lib/components for shared
- **Angular:** standalone component with signals for state

### Component Quality

Every component must:
- Accept all data via props — no internal fetching unless explicitly a container
- Handle loading/empty/error states (or accept them as props)
- Be accessible: semantic HTML, ARIA labels, keyboard navigation, focus management
- Be responsive unless explicitly fixed-width
- Use project's existing styling approach — don't mix Tailwind and CSS modules

### Composition
- Prefer composition over configuration — small focused components over mega-components
- Extract hooks/composables for reusable logic
- Keep render logic readable — extract sub-components if JSX exceeds ~50 lines

## STEP 4: VERIFY

1. Build passes — no type errors
2. Renders correctly (check via storybook or dev server if available)
3. Tests pass: component renders, props work, interactions fire, states display
4. Accessibility: run axe check if available, verify keyboard nav manually
5. Commit: `git add [files] && git commit -m "feat: add [ComponentName] component"`

## STEP 5: OUTPUT SUMMARY

```
## Component Generated: [name]

### Files
- [file 1] — [what]
- [file 2] — [what]

### Props
[prop: type] — [description]
...

### States Handled
Default | Loading | Empty | Error

### Tests
[N] tests — [what they cover]

### Usage
```[lang]
<ComponentName prop={value} onEvent={handler} />
```

### Next Steps
- /test — add interaction + edge case tests
- /doc — add to component catalog
- /review — check accessibility + patterns
```

## COMPONENT RULES
- **Match the codebase** — follow existing file structure, naming, styling exactly
- **Props are the API** — type them strictly, document non-obvious ones
- **Accessibility is not optional** — semantic HTML, ARIA, keyboard nav, focus management
- **States are not optional** — loading, empty, error. Users see these more than the happy path
- **Don't fetch in components** — components render data. Containers/pages fetch it
- **Composition over config** — prefer `<Card><CardHeader/>` over `<Card headerVariant="large">`
- **Test what users see** — test rendered output and interactions, not implementation details
- **No inline styles** — use the project's styling system
