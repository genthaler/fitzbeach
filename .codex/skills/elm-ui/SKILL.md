---
name: "elm-ui"
description: "Use when tasks involve `mdgriffith/elm-ui`, including layout composition, spacing, typography, attribute helpers, and small UI changes in Elm projects. Prefer existing project helpers and visual patterns instead of introducing raw HTML or new styling systems."
---

# Elm UI Skill

## When to use
- Adjust Elm layouts built with `mdgriffith/elm-ui`.
- Add or refine spacing, typography, grouping, surfaces, and controls in Elm UI code.
- Convert a small raw HTML view into an existing `elm-ui` approach when the project already uses `elm-ui`.

## When not to use
- Pure visual review with little or no code editing.
- Non-Elm styling systems or projects that do not already use `elm-ui`.

## Workflow
1. Inspect nearby view helpers first.
   - Reuse existing spacing, typography, and container helpers before creating new ones.
   - Match the surrounding attribute and layout style.
2. Prefer straightforward composition.
   - Use `row`, `column`, `el`, wrapped text, and simple helper functions over clever abstractions.
   - Keep hierarchy readable.
3. Keep helper additions justified.
   - Avoid one-off style helpers unless they will be reused immediately.
4. Keep the visual language consistent.
   - Reuse existing rhythms for spacing, text hierarchy, borders, and surfaces.
   - Avoid adding a parallel styling approach.
5. Check responsive behaviour.
   - Watch for mobile wrapping, overflow, and awkward text breaks when changing layout.
6. Preserve interaction clarity.
   - Keep labels, button copy, focus states, and contrast clear.
7. Validate the UI change with the project's normal build command.

## Fixing guidance
- Prefer `elm-ui` primitives over raw HTML in Elm when the project already uses `elm-ui`.
- Keep helper additions small and local.
- Maintain accessible labels, focus states, and readable contrast.
- Preserve compilability while changing views.

## Final checks
- Layout code is readable.
- New helpers are justified and reused.
- Interactive elements remain clear and accessible.
- The relevant Elm or project build command has been run.
- The relevant build passes, or the inability to run it is stated clearly.
