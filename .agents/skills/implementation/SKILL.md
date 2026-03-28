# Implementation

Execute a directed implementation task in this repo with minimal prompt overhead, preserving existing behavior outside the requested change and coordinating narrower local skills when needed.

## When to use

- When the user asks to implement a feature, enhancement, or directed change
- When the task is straightforward execution rather than a review or broad refactor
- When the user provides a finding, spec, or request and expects code changes rather than planning

## When not to use

- When the task is primarily a bug fix or regression correction; use `fixing` instead
- When the task is primarily a bounded structural cleanup; use the shared `refactoring` skill instead
- When the task is a review, audit, or analysis with no requested code changes

## Workflow

1. Inspect the relevant code paths and determine the smallest coherent change that satisfies the request.
2. Execute the change directly rather than rewriting repo instructions in the prompt or response.
3. Pull in narrower local skills only when the task clearly needs them, such as `elm`, `elm-ui`, `elmbook`, `elm-testing`, `readme-sync`, or `git`.
4. Preserve unrelated behavior, UI, and structure unless the request explicitly calls for broader changes.
5. Update tests, ElmBook examples, and README only when the implementation makes them inaccurate.
6. Follow the repo-wide verification and commit requirements from `AGENTS.md`.

## Fixing guidance

- If the task starts expanding into multiple unrelated changes, narrow it to the smallest shippable implementation step.
- If a requested change is awkward to test, use `elm-testing` to add or improve coverage rather than skipping tests silently.
- If the task turns out to be primarily corrective rather than additive, switch to the `fixing` skill instead of forcing it through an implementation workflow.

## Final checks

- The requested change has been implemented directly and narrowly.
- Supporting updates to tests, ElmBook, or README have been made only where needed.
- The repo-wide verification requirement from `AGENTS.md` has been met, or any inability to run it is stated clearly.
- The repo-wide commit requirement from `AGENTS.md` has been met.
