# Architecture

<!-- FILL this in for your project. Keep it to what an agent (or new hire) needs before a
     cross-module change. Update it in the same PR that changes a boundary. -->

## System in one paragraph
FILL: e.g. Web app (Next.js) → API (Fastify) → Postgres. Background jobs on a queue.

## Modules and boundaries
| Module | Owns | May call | Must not |
| --- | --- | --- | --- |
| FILL `src/web` | UI | `src/api` over HTTP | import API code directly |
| FILL `src/api` | HTTP handlers, services | `src/db` | talk to the DB except through `src/db` |
| FILL `src/db` | schema, queries | — | contain business logic |

## Data flow for a typical request
1. FILL: handler validates input
2. FILL: service applies business rules
3. FILL: repository reads/writes

## Key decisions
See `docs/adr/`. One line each here:
- 0001: Record architecture decisions as ADRs.
- FILL

## Known sharp edges
- FILL: areas with no tests, legacy code, things to ask before changing.
