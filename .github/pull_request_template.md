## What and why
<!-- One or two sentences. Link the issue or spec. -->

## Written with an agent?
<!-- Which tool/model, and link or paste the PLAN.md summary. Delete if not applicable. -->

## Verification
- [ ] Tests run and pass — command and result:
- [ ] Lint and typecheck clean
- [ ] Diff touches only what the task needed (no stray edits to generated files, lockfiles, config)
- [ ] No tests weakened, skipped or deleted to make them pass
- [ ] Meets the spec's acceptance criteria (not a nearby easier problem)
- [ ] No new dependency, secret or network call I didn't expect
- [ ] Any MCP write actions (posts, comments, resource changes) were intended
- [ ] Infra: plan/preview reviewed; change goes through CI, not the agent session
- [ ] `ARCHITECTURE.md` / `DESIGN.md` / `AGENTS.md` updated if this made them untrue
