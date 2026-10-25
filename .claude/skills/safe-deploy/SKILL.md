---
name: safe-deploy
description: Use when asked to deploy, provision, or change cloud infrastructure (AWS, Google Cloud, Azure). Changes IaC, runs a plan/preview against dev only, and stops for human approval.
---

# Safe deploy

Follow these steps in order. Stop at step 5.

1. Read `docs/DEPLOY.md` and `infra/AGENTS.md`. Use only the dev/sandbox identity and IDs listed there.
   If they are missing or still say FILL, stop and ask.
2. Make the change in infrastructure code under `infra/` only. Never create or change resources
   with direct API, CLI or MCP write calls.
3. Run the matching validation:
   - Terraform: `terraform fmt -check && terraform validate`
   - CDK: `cdk synth`
   - Azure: `azd provision --preview`
4. Run the plan against dev and capture the output:
   - Terraform: `terraform plan`
   - CDK: `cdk diff`
5. Paste a short summary (resources added / changed / destroyed, any replacements, IAM or
   network changes, estimated cost impact if known) and STOP for human approval.
6. After approval, do not apply. Open a PR; CI applies to dev, and production goes through
   the release pipeline.

Read-only cloud MCP calls (logs, metrics, describe/list) are fine at any step.
