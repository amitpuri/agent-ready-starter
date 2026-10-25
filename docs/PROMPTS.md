# Reusable prompts for coding agents

Copy, fill the `<...>` parts, paste.

## Plan first
Read @AGENTS.md and @docs/specs/<feature>.md. Write a step-by-step plan to PLAN.md with the
files you'll touch and the tests you'll add. Don't write code yet. Ask me up to 5 questions
first if anything is unclear.

## Implement the plan
Implement PLAN.md one step at a time. After each step, run the tests and lint, tick the step,
and stop if anything fails.

## Explore before touching
Explain how <feature> works today: entry points, data flow, and the files involved.
Don't change anything.

## Root cause, not patch
Find the root cause of this failure before changing code. Show the evidence (log lines,
failing test), then propose the smallest fix.

## Tight scope
Only change <file/function>. Don't refactor, rename or reformat anything else.
Show the diff summary.

## Self-review
Review your own diff as a skeptical senior engineer. List the top 5 risks in order of
severity, then fix the ones you agree with.

## Update the docs
Update ARCHITECTURE.md and AGENTS.md for anything this change made untrue.
Show me the doc diff separately.

## Write the rule
You made the same mistake twice. Propose one line for AGENTS.md that would have prevented it.

## Hand-off
Update PLAN.md with what's done, what's left, decisions made and open questions, so a fresh
session can continue.

## Ticket → spec
Read the <Notion page / GitHub issue> "<name>". Write docs/specs/<feature>.md from it using
docs/specs/TEMPLATE.md. List anything the source leaves unclear as open questions.

## Safe deploy
Change the IaC only. Run the plan/preview against the dev environment, paste the summary,
and stop for my approval.

## Short follow-ups
- plan first, don't code yet
- ask before you guess — list your assumptions
- smallest change that fixes it
- don't touch anything outside this file
- run the tests and show me the output
- what did you not verify?
- do not make up APIs; if you don't know, say so and check the docs
- re-read AGENTS.md and check you've followed every rule
