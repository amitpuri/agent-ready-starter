# tests/AGENTS.md

Applies when working in `tests/`. Root AGENTS.md still applies.

- One behaviour per test; name tests `<unit>_<behaviour>_<condition>` (FILL if your convention differs).
- A bug fix starts with a failing test that reproduces the bug.
- No sleeps and no real network calls; use fakes/fixtures (FILL: where they live).
- Never loosen an assertion, add a skip, or delete a test to make it pass. Say why it fails and stop.
- Mirror `src/` layout so every module has an obvious test file.
