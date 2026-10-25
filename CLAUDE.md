@AGENTS.md

## Claude Code only

<!-- Shared rules live in AGENTS.md (imported above). Keep this section short. -->

- Use plan mode for changes under `infra/` and for anything touching auth or payments.
- Folder-scoped rules shared with other tools live in nested `AGENTS.md` files (`infra/`, `tests/`).
  Add Claude-only path rules under `.claude/rules/` with `paths:` frontmatter if you need them.
- Repeatable procedures live in `.claude/skills/` — e.g. `safe-deploy`.
- Run `/context` to confirm this file and AGENTS.md loaded; run `/doctor prompt-audit`
  occasionally to find stale or conflicting instructions.
