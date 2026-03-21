# Elm Parcel App Skill

## When to use
- Modify an Elm browser app that is bundled with Parcel.
- Debug simple bootstrapping issues between Elm, `index.js`, and `index.html`.
- Make small app changes while preserving the existing Parcel setup.

## When not to use
- Pure Elm module work that does not touch app entrypoints or bundling concerns.
- Tasks that require broader bundler reconfiguration unless explicitly requested.

## Workflow
1. Check the app entrypoints first.
   - Read `elm.json`, `src/Main.elm`, `index.js`, and `index.html`.
   - Confirm the Elm module being initialised matches the HTML mount point.
   - Re-check that `index.html`, `index.js`, and the Elm module name still agree after refactors.
2. Preserve the simple setup.
   - Keep `index.js` limited to bootstrapping unless the project already does more.
   - Avoid adding extra framework or bundler complexity unless required.
   - Avoid changing bundler config unless the task clearly requires it.
3. Validate with the smallest useful command.
   - Prefer `elm make` for quick compile feedback.
   - Use `npm run build` or the project's Parcel build command when integration matters.

## Fixing guidance
- Re-check `index.js`, `index.html`, and the Elm module name together after any refactor that touches bootstrapping.
- Keep `index.js` focused on starting the Elm app unless the repository already has explicit extra responsibilities there.
- Prefer the smallest compile or build command that proves the boot path still works before moving on.

## Final checks
- The app still mounts into the expected element.
- Elm and JS entrypoints stay consistent.
- Relevant validation has been run with `elm make`, `npm run build`, or the repo's Parcel command as appropriate.
- The relevant build passes, or the inability to run it is stated clearly.
