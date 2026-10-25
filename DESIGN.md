# Design system

<!-- FILL for any project with a UI. Delete this file if there is none (and remove it from
     AGENTS.md). Pull real tokens from your design tool or brand kit; don't let the agent guess. -->

## Tokens
- Colors: CSS variables from FILL `styles/tokens.css`; never hex literals in components.
- Spacing scale: FILL e.g. 4, 8, 12, 16, 24, 32 px
- Type: FILL e.g. Inter; body 16/24, small 14/20
- Radius / shadows: FILL

## Components
- Use components from FILL `src/web/components/ui/` before writing new ones.
- Buttons: FILL e.g. `<Button variant="primary|secondary|ghost">` only
- Forms: label above field; errors below in the danger colour

## Accessibility
- Every interactive element is keyboard reachable with a visible focus ring.
- Body text contrast ≥ 4.5:1.
- Images have alt text; icons-only buttons have an accessible label.

## Do / don't
- Do: reuse existing components and tokens.
- Don't: add a new UI or modal library without an ADR.
