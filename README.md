# Agent-ready starter

A starter layout for repositories that coding agents work in — Claude Code (desktop and CLI),
Google Antigravity, Cursor, VS Code, Devin Desktop (formerly Windsurf) and Devin.
It is the companion to the article **"Get the Most Out of Coding Agents"**.

It is stack-agnostic: copy the files into a new or existing repo, then replace every `FILL`.

## What's inside

```
AGENTS.md                  Canonical instructions — every tool reads this
CLAUDE.md                  @AGENTS.md + Claude-only extras
GEMINI.md                  Antigravity-only overrides (keep tiny)
infra/AGENTS.md            Scoped rules for infrastructure work
tests/AGENTS.md            Scoped rules for tests
ARCHITECTURE.md            Modules, boundaries, decisions, sharp edges
DESIGN.md                  Tokens, components, accessibility
SECURITY.md                Secrets, prompt injection, human-review areas
CONTRIBUTING.md            Branches, commits, PRs
PLAN.md                    The agent's working plan for the current task
docs/DEPLOY.md             Environments + the agent's non-production identity
docs/PROMPTS.md            Reusable prompts and short follow-ups
docs/specs/TEMPLATE.md     Write tasks as specs, not sentences
docs/adr/                  Architecture decision records
.claude/settings.json      Claude Code permissions: deny secrets, ask before push, no apply/deploy
.claude/skills/safe-deploy Plan-only infrastructure procedure (loaded on demand)
.vscode/settings.json      Turns on AGENTS.md (incl. nested) for VS Code's Local harness
.mcp.json.example          Claude Code MCP servers: GitHub (read-only), Notion, Slack, Canva
.cursor/mcp.json.example   Same servers for Cursor
.github/pull_request_template.md   Verification checklist for agent-written PRs
.github/workflows/agent-context.yml Runs the context check on every PR
scripts/check-agent-context.sh     Lints the context files themselves
```

## Set it up (about an hour)

1. Copy everything into your repo (keep the dot-folders).
2. Fill `AGENTS.md` first: real commands, layout, generated-file paths, where things live.
   Keep it under ~150 lines.
3. Fill `ARCHITECTURE.md`, `docs/DEPLOY.md`, and `DESIGN.md` (or delete `DESIGN.md` if there's no UI).
4. Connectors — pick the ones you use:
   - Claude Code: `cp .mcp.json.example .mcp.json`, delete servers you don't need, commit it.
     Export `GITHUB_PAT` in your shell (a fine-grained, read-only token). Claude Code asks you
     to approve project servers the first time.
   - Cursor: `cp .cursor/mcp.json.example .cursor/mcp.json` (gitignored — it's per user).
   - VS Code, Antigravity, Devin Desktop: add the same server URLs through each tool's MCP UI.
5. Run `./scripts/check-agent-context.sh` until it passes. It fails while any `FILL` is left.
6. Verify each tool actually loads the files:
   - Claude Code: `/context` (look under Memory files)
   - VS Code: expand **References** on a response
   - Cursor: Customize → Rules
   - Antigravity: the Rules panel

## How each tool picks this up

| Tool | Reads | Notes |
| --- | --- | --- |
| Claude Code | `CLAUDE.md` → imports `AGENTS.md` | With a `CLAUDE.md` present, Claude Code doesn't read `AGENTS.md` on its own — the `@AGENTS.md` import is what brings it in. |
| Antigravity | `AGENTS.md`, `GEMINI.md` | Keep `GEMINI.md` from contradicting `AGENTS.md`; precedence isn't documented. |
| Cursor | `AGENTS.md` (root + nested), `CLAUDE.md` | Add `.cursor/rules/*.mdc` only if you need glob/description activation. Plain `.md` files there are ignored. |
| VS Code | `AGENTS.md` | `.vscode/settings.json` turns on nested `AGENTS.md` (experimental) and turns off `CLAUDE.md` so content isn't loaded twice. |
| Devin Desktop | `AGENTS.md` (root always on, subfolders scoped) | Old `.windsurf/rules/` still load; new rules go in `.devin/rules/`. |
| Devin (cloud) / CLI | `AGENTS.md` | Also run Devin's repo setup so it can install and test. |

## Working loop

1. Write the task as `docs/specs/<feature>.md` (or have the agent draft it from the ticket).
2. "Plan first" prompt → review and edit `PLAN.md`.
3. "Implement the plan" prompt → tests and lint after each step.
4. "Self-review" prompt → read the diff yourself → PR with the checklist filled in.
5. Agent repeats a mistake? Add one line to `AGENTS.md`.

## Guardrails worth knowing

- Instruction files are context, not enforcement. The hard stops are in `.claude/settings.json`
  (and your CI). Other tools have their own permission and hook settings — set the equivalent there.
- A `Read` deny rule doesn't stop `cat .env` in a shell. Keep real secrets out of the working tree.
- Treat anything fetched through connectors as data, not instructions (see `SECURITY.md`).
- Cloud MCP servers: non-production identity only; production goes through CI.

## Keep it current

Review these files monthly. Delete rules the agent now follows without being told, and
re-check vendor docs — file names and defaults changed several times in 2025–26.
