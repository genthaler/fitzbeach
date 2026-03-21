# Elm Testing

Add or improve Elm test coverage in this repo, especially around behavior seams, pure helpers, and feature or module contracts.

## When to use

- When adding tests for uncovered Elm behavior in this repository
- When fixing a test coverage gap review finding
- When making a small Elm refactor whose main purpose is testability rather than feature work

## When not to use

- When the task is general Elm implementation or refactoring without a testing focus; use `elm` instead
- When the task is specifically about `elm-review` failures or review config; use `elm-review` instead
- When the task is UI review, documentation, bootstrapping, or deploy workflow work

## Workflow

1. Inspect the target Elm module and its existing tests before editing anything.
2. Decide whether to test the existing public API directly or to extract a small pure helper to expose the behavior under test.
3. Keep behavior unchanged. If a helper is extracted for testability, keep it narrow and tied to the existing feature seam.
4. Place tests in the matching namespace under `tests/`, following the repo convention that the test for a module should be in the same namespace as the tested module.
5. Prefer testing behavior contracts over implementation detail. Focus on state transitions, pure decisions, and feature boundaries rather than brittle rendering internals.
6. Run `npm test` first, then follow the repo-wide final verification requirement from `AGENTS.md` once the targeted tests pass.

## Fixing guidance

- Do not try to compare opaque Elm runtime values such as `Sub` directly; extract pure boolean or configuration helpers when needed.
- If view behavior is awkward to test directly, prefer testing small pure helpers or state/config decisions instead of snapshot-style assertions.
- If the module already has indirect coverage, add tests only for the uncovered seam rather than duplicating broader integration coverage.
- Keep helper exports intentional. Expose a pure helper only when it represents a stable behavior contract worth pinning in tests.

## Final checks

- The new or updated tests live in the matching namespace under `tests/`.
- The changed behavior seam is covered directly and narrowly.
- `npm test` has been run.
- The repo-wide final verification requirement from `AGENTS.md` has been met, or any inability to run it is stated clearly.
