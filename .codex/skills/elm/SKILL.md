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

## Workflow
1. Inspect the project shape first.
   - Read `elm.json` and the relevant Elm modules.
   - Prefer existing naming, module structure, helper patterns, and TEA flow over new abstractions.
2. Keep changes small and compiler-friendly.
   - Prefer explicit top-level type annotations.
   - Make invalid state unrepresentable when changing models or messages.
   - Reuse existing `Msg`, `Model`, `init`, `update`, and `view` patterns before adding new ones.
3. For JSON work, use explicit decoders and encoders.
   - Match the decoder style used nearby.
   - Do not silently make fields optional unless the API requires it.
4. Validate after meaningful edits.
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
- Check pattern matches for exhaustiveness.
- Keep `init`, `update`, subscriptions, and `view` consistent.

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
