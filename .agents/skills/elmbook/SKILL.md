# ElmBook Skill

## When to use
- Add, update, or reorganize ElmBook chapters.
- Document reusable Elm UI components, controls, or full-page examples in ElmBook.
- Maintain shared ElmBook state used across interactive examples.
- Align ElmBook chrome and theme options with the host application's palette and UI language.
- Debug ElmBook-specific entrypoints, build issues, or chapter wiring.

Use alongside the `elm` skill when chapter updates require non-trivial Elm refactors.
Use alongside the `elm-ui` skill when the documented components are built with `mdgriffith/elm-ui`.

## When not to use
- When the task is limited to main-app Elm code with no catalogue or chapter impact.
- When the work is purely visual review without ElmBook implementation changes.
- When the request is general bundler or deploy work unrelated to ElmBook.

## Workflow
1. Inspect the ElmBook setup first.
   - Read the ElmBook entry module and the existing chapter modules.
   - Check how shared state, fixtures, and chapter grouping are organized before adding new examples.
2. Prefer documentation that mirrors real UI code.
   - Reuse the same theme, helpers, and component APIs used by the app.
   - Avoid creating a separate presentation style just for the catalogue.
3. Keep chapters focused.
   - Use a chapter per component, control, or page-sized example unless the existing project groups them differently.
   - Show the smallest meaningful set of states rather than every possible permutation.
4. Treat shared state deliberately.
   - Only add to shared ElmBook state when multiple chapters benefit from it.
   - Keep fixtures and demo state explicit and easy to reset.
5. Keep ElmBook theme configuration aligned with the app.
   - Reuse app palette and theme helpers when possible.
   - If dark mode or custom chrome is supported, update both light and dark behaviour together.
6. Validate with the project's ElmBook command.
   - Prefer the dedicated ElmBook build or verification script, then broader project validation if shared UI changed.

## Fixing guidance
- Prefer documenting stable, reusable surfaces over one-off internal fragments.
- For interactive examples, expose the real messages or state transitions rather than mock-only placeholders when practical.
- Group chapters by domain such as foundations, components, and pages if the catalogue is large enough to justify structure.
- Keep ElmBook colors, navigation chrome, and background treatment consistent with the host app.
- Reuse existing color conversion or theme helpers instead of duplicating palette logic.
- If ElmBook requires CSS overrides, keep them narrow and clearly tied to ElmBook chrome.
- Prefer the smallest command that validates the change, but run the broader verification command when shared UI or theme code changed.

## Final checks
- ElmBook still boots from its dedicated entrypoint.
- New or updated chapters use existing component and theme patterns.
- Relevant validation has been run with commands such as `npm run book`, `npm run book:build`, or `npm run verify` as appropriate.
- The ElmBook build passes, or any inability to run it is stated clearly.
