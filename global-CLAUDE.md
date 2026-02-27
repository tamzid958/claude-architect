# Global Defaults

## Code Style
- Prefer modern language idioms over legacy patterns
- Strong/strict typing when available
- Prefer functional patterns; avoid classes unless idiomatic for the language
- Always add error handling — never leave catch blocks empty
- Use the language's standard module system

## Workflow
- Always create a git branch before making changes
- Run typecheck/lint after every file change
- Write tests alongside implementation, not after
- Commit after each logical unit of work
- Use /clear between major phases to manage context

## Communication
- When asked to plan, output a numbered step list — no prose
- When implementing, show file path before code
- Flag assumptions explicitly with [ASSUMPTION]

## Quality Gates
- Build/compile must pass with zero warnings before moving on
- Linter must pass with zero errors
- No TODO/FIXME comments left unresolved
- .gitignore covers dependencies, build output, env files, IDE config
