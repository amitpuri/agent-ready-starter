# infra/AGENTS.md

Applies when working in `infra/`. Root AGENTS.md still applies.

- Change infrastructure only through code in this folder (FILL: Terraform / CDK / Bicep / azd).
- Never create, change or delete cloud resources with direct API or CLI calls.
- Always run the plan/preview against the dev environment and paste the summary, then stop:
  - Terraform: `terraform plan`
  - CDK: `cdk diff`
  - Azure: `azd provision --preview`
- Never apply to production. Production changes go through CI after human approval.
- Use only the non-production identity and account/project/subscription IDs in `docs/DEPLOY.md`.
- Tag every resource with `owner`, `env` and `managed-by=iac`.
