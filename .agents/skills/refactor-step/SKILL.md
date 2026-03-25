# Refactor Step

Make one bounded structural improvement while preserving current behaviour, keeping the project compilable, and avoiding speculative redesign.

## When to use

- When a task is an incremental refactor or architecture cleanup rather than a new feature
- When extracting a feature boundary, moving state ownership, or simplifying module responsibilities
- When the user wants a behaviour-preserving cleanup with verification and a commit

## When not to use

- When the task is primarily a new feature with only incidental cleanup
- When the work is mainly a UI review or bug investigation
- When the requested change requires a broad redesign rather than one bounded refactor step

## Workflow

1. Inspect the current code paths before editing and identify the exact boundary to improve and the smallest set of modules involved.
2. Preserve behaviour first. Do not change visuals, copy, interaction timing, or routing unless the refactor requires it.
3. Keep abstractions local. Prefer introducing one focused module or type over broad framework-style restructuring.
4. Use existing local skills that overlap with the refactor when relevant, especially `elm`, `elm-ui`, `elmbook`, `readme-sync`, and `git`.
5. Preserve Parcel and ElmBook bootstrapping:
   - `index.js` must still initialise `Elm.Main`
   - `book.js` must still initialise `Elm.Book`
6. Update tests that cover the moved or delegated behaviour. Add new tests only when they protect the new seam introduced by the refactor.
7. Check whether ElmBook examples or README architecture notes became inaccurate. Update them only where the refactor changed the public structure or workflow.

## Fixing guidance

- If the refactor starts forcing unrelated edits across many modules, narrow the scope and complete a smaller step first.
- If temporary bridging types or message wrappers are introduced, remove them when they are only scaffolding and no longer clarify ownership.
- If UI code is touched during the refactor, keep it consistent with the repo's calm design language rather than restyling during structural work.

## Final checks

- Summarise the architectural change in terms of ownership and boundaries, not file churn.
- Note whether behaviour was intentionally unchanged.
- Run `nix develop -c npm run verify` before finishing when possible.
- Commit the completed change.
