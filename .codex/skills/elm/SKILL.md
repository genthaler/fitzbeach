---
name: "elm"
description: "Use when tasks involve Elm applications or libraries, especially The Elm Architecture, compiler-guided refactors, decoders and encoders, type-safe model changes, and small updates that preserve compilability. Prefer existing project patterns, explicit top-level types, and minimal changes."
---

# Elm Skill

## When to use
- Build or modify Elm applications or packages.
- Refactor Elm code with compiler guidance.
- Debug Elm compile errors, imports, pattern matches, decoders, or TEA wiring.

For `elm-ui` layout and styling work, also use the `elm-ui` skill when available.

## When not to use
- Pure styling or layout review without meaningful Elm logic changes.
- Bundler or bootstrapping work where the `elm-parcel-app` skill is a better fit.

## Workflow
1. Inspect the project shape first.
   - Read `elm.json` and the relevant Elm modules.
   - Prefer existing naming, module structure, helper patterns, and TEA flow over new abstractions.
2. Keep changes small and compiler-friendly.
   - Prefer explicit top-level type annotations.
   - Make invalid state unrepresentable when changing models or messages.
   - Reuse existing `Msg`, `Model`, `init`, `update`, and `view` patterns before adding new ones.
3. Use compiler-guided iteration.
   - Make one meaningful type or API change at a time.
   - Recompile before expanding the refactor so errors stay local and easy to resolve.
4. Keep logic readable.
   - Prefer small pure helpers over growing inline conditionals in `view` and `update`.
5. For JSON work, use explicit decoders and encoders.
   - Match the decoder style used nearby.
   - Do not silently make fields optional unless the API requires it.
6. Validate after meaningful edits.
   - Run the smallest relevant check first, usually the Elm build or the project's standard build command.
   - Fix compiler warnings or errors before expanding the change.

## Common checks
- `elm make src/Main.elm`
- `npm run build`
- `npm test`

Use the checks that exist in the current project. Prefer the smallest command that validates the change.

## TEA expectations
- Keep state transitions predictable and local.
- Update all affected call sites when changing a type.
- Update all branches when changing a custom type.
- Check pattern matches for exhaustiveness.
- Keep `init`, `update`, subscriptions, and `view` consistent.

## Module structure
- Prefer module names that describe the architectural role they play, not generic placeholders.
- When a feature or page owns its own nested Model-View-Update boundary, prefer naming that module `Page`.
- Use `View` for modules that are focused on rendering and view helpers only.
- Keep `Model` for domain data, invariants, and lower-level state types, rather than page-level orchestration modules.
- Avoid `Main` for nested feature modules unless they are actual application entrypoints; in Elm codebases, `Main` strongly suggests a boot module.
- When splitting a feature across modules, prefer names that make the boundary obvious at a glance, such as domain `Model`, orchestration `Page`, and rendering `View`.

## Refactoring guidance
- Prefer compiler-guided renames and type changes.
- Avoid unnecessary module splits or architecture changes.
- Preserve public names unless the task requires otherwise.
- Do not leave placeholder implementations.

## `elm-test` guidance
- The test for a module should be in the same namespace as the tested module.

## Final checks
- Imports are tidy.
- Top-level types are present where expected by the project.
- Pattern matches are exhaustive.
- The relevant build or test command passes, or any inability to run it is stated clearly.
