# Fixing

Execute a targeted corrective change in this repo, treating the reported problem as the contract and favouring the smallest defensible fix with regression protection.

## When to use

- When the user asks to fix a bug, address a review finding, or correct a regression
- When a specific failure mode or behavioral issue has already been identified
- When the task is a bounded correction rather than a new feature

## When not to use

- When the task is primarily new feature implementation; use `implementation` instead
- When the task is primarily a bounded structural cleanup with no corrective focus; use the shared `refactoring` skill instead
- When the task is a review or investigation with no requested code changes

## Workflow

1. Treat the reported bug, finding, or regression as the behavioral contract to satisfy.
2. Inspect the relevant code paths and choose the smallest coherent fix that resolves the issue without broad redesign.
3. Pull in narrower local skills only when needed, especially `elm`, `elm-testing`, `elm-ui`, `readme-sync`, or `git`.
4. Preserve unrelated behavior and avoid opportunistic cleanup unless it is required to land the fix safely.
5. Add or update regression coverage when the bug or finding is testable.
6. Follow the repo-wide verification and commit requirements from `AGENTS.md`.

## Fixing guidance

- If multiple possible fixes exist, prefer the one with the smallest blast radius and the clearest behavioral contract.
- If a bug cannot be tested directly, add the narrowest pure helper or regression seam that makes the fix defensible.
- If the work starts turning into a feature or refactor, switch to `implementation` or the shared `refactoring` skill instead of expanding the fix scope silently.

## Final checks

- The reported issue is resolved with the smallest coherent change.
- Regression coverage has been added or updated when appropriate.
- The repo-wide verification requirement from `AGENTS.md` has been met, or any inability to run it is stated clearly.
- The repo-wide commit requirement from `AGENTS.md` has been met.
