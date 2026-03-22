# UI Review

Review the implemented UI with a code-review mindset, prioritising user-facing risks, regressions, accessibility issues, and places where the calm design intent breaks down in practice.

## When to use

- When the user asks for a UI review, design review, presentation review, or accessibility review
- When the user wants feedback on responsiveness, interaction clarity, or visual consistency
- When reviewing Elm UI code for regressions after a refactor or feature change

## When not to use

- When the user wants implementation changes rather than a review
- When the task is mainly an architecture review with little UI impact
- When reviewing non-UI code paths such as deploy scripts, tests, or domain logic

## Workflow

1. Review the implemented UI modules directly rather than relying on README claims.
2. Check accessibility first:
   - keyboard navigation
   - visible focus states
   - semantic labels and descriptions
   - non-visual understanding of interactive state
   - contrast risks
3. Check responsiveness:
   - narrow-screen layout
   - first-render behaviour
   - overflow or cramped controls
   - consistency between compact and wider layouts
4. Check presentation consistency:
   - calm palette and restrained typography
   - spacing rhythm
   - component consistency across pages and ElmBook
   - avoidance of decorative or noisy UI
5. Check robustness:
   - multi-instance rendering issues
   - hardcoded visual assumptions
   - fragile IDs or duplicated semantics
6. Report findings first, ordered by severity, with file and line references.

## Fixing guidance

- If a potential issue depends on runtime or browser behaviour you did not verify visually, state that as an assumption or residual risk.
- If there are no findings, say so explicitly rather than padding the review with low-signal observations.
- Keep summaries brief and secondary; do not let general commentary displace concrete findings.

## Final checks

- Ensure findings are prioritised and actionable.
- Ensure each finding includes a file reference and tight line reference when possible.
- Use the repo's existing design language as the standard: calm, minimal, premium product page rather than dashboard.
- If no findings were discovered, mention any residual testing or browser-validation gaps.
