# Contributing

Applies to people and coding agents alike.

## Branches and commits
- Branch from `main`: `feat/<short-name>`, `fix/<short-name>`, `chore/<short-name>`.
- Commit messages: FILL e.g. Conventional Commits (`feat: add CSV export`).
- Never push to `main` directly; never force-push shared branches.

## Pull requests
- One concern per PR. Link the issue or spec.
- Fill in the PR template checklist, including how the change was verified.
- If an agent wrote most of the change, say which one and attach `PLAN.md` or its summary.
- Update `ARCHITECTURE.md`, `DESIGN.md` or `AGENTS.md` in the same PR if the change makes them untrue.

## Before you request review
- FILL: tests command
- FILL: lint + typecheck command
- `./scripts/check-agent-context.sh`
