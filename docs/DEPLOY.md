# Deployment

<!-- Agents may only use the non-production values below. Do not list production
     credentials or secrets here. -->

## Environments
| Env | Purpose | Who deploys | How |
| --- | --- | --- | --- |
| dev | agent and developer testing | CI on merge to a feature branch / FILL | FILL |
| staging | pre-release checks | CI on merge to `main` / FILL | FILL |
| prod | customers | release pipeline after human approval | FILL |

## Non-production identity for agents
| Cloud | Identity | Account / project / subscription | Region |
| --- | --- | --- | --- |
| AWS | FILL role name | FILL dev account ID | FILL |
| Google Cloud | FILL service account | FILL dev project ID | FILL |
| Azure | FILL service principal / managed identity | FILL dev subscription ID | FILL |

Delete rows for clouds you don't use.

## Infrastructure as code
- Tool: FILL (Terraform / CDK / Bicep / azd)
- Location: `infra/`
- Plan/preview: FILL exact command
- Naming: FILL e.g. `<app>-<env>-<component>`
- Required tags: `owner`, `env`, `managed-by=iac`

## Cloud MCP servers
- AWS: AWS MCP Server (Agent Toolkit for AWS). Remove older `aws-api-mcp-server` /
  `aws-knowledge-mcp-server` entries to avoid overlapping tools.
- Google Cloud: Google-managed remote MCP servers (e.g. Cloud Run) or the `gcloud` MCP server.
- Azure: Azure MCP Server (tools are off by default in supported hosts).

Read-only use (logs, metrics, describe/list, cost) is always fine. Writes go through IaC + CI.

## Audit
- AWS CloudTrail · Google Cloud Audit Logs · Azure activity log — FILL where to look.
