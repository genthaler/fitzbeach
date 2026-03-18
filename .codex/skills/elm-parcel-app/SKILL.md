---
name: "elm-parcel-app"
description: "Use when working on Elm apps booted with Parcel. Inspect `elm.json`, `src/Main.elm`, `index.js`, and `index.html`, keep the bootstrapping simple, and validate with the smallest relevant Parcel or Elm build command."
---

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

## Final checks
- The app still mounts into the expected element.
- Elm and JS entrypoints stay consistent.
- The relevant build passes, or the inability to run it is stated clearly.
