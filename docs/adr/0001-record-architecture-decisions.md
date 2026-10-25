# 0001: Record architecture decisions

- Status: accepted
- Date: FILL

## Context
Coding agents start every session with no memory of why the code looks the way it does.
Without a record, they (and new contributors) reopen settled decisions or quietly break them.

## Decision
Record each significant architecture decision as a short ADR in `docs/adr/`, numbered in
order, using `docs/adr/TEMPLATE.md`. List each one in one line in `ARCHITECTURE.md`.

## Consequences
- Agents read the relevant ADR before changing a boundary it covers.
- A change that reverses an ADR needs a new ADR that supersedes it, in the same PR.
