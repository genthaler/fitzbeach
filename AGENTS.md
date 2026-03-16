# AGENTS.md

## Project

- Name: `fitzbeach`

## Stack
- Elm
- `mdgriffith/elm-ui`
- Parcel

## Goals
- Keep this project minimal and easy to iterate on
- Preserve compileability at all times when possible
- Prefer small, local changes
- Keep the existing architecture unless explicitly asked to change it
- Do not invent new patterns where existing project patterns already exist

## Structure

- `src/Main.elm`: Elm entry point and UI
- `index.js`: boots the compiled Elm app into `#app`
- `index.html`: minimal HTML shell for Parcel
- `package.json`: JS tooling only

## Documentation

- Keep `README.md` aligned with the current app behaviour, setup steps, and architecture notes.
- When a change affects user-visible features, controls, setup, or project structure, update `README.md` if needed.
- Do not describe planned features in `README.md` as if they already exist.

## Working Rules

- Prefer small, focused changes.
- Do not add extra frameworks or runtime dependencies unless explicitly requested.
- Keep the Parcel setup simple.
- Keep the Elm app minimal and readable.
- Use `elm-ui` for layout instead of raw HTML in Elm when adjusting the UI.

## Commands

- Install JS dependencies: `npm install`
- Start dev server: `npm run dev`
- Build production bundle: `npm run build`

## Notes

- The app mounts into `<div id="app"></div>` in `index.html`.
- `index.js` should continue to initialise `Elm.Main`.
- If Elm dependencies are added later, keep them intentional and minimal.

## Elm conventions
- Follow The Elm Architecture
- Prefer explicit types on top-level definitions
- Prefer small pure helper functions
- Reuse existing Msg, Model, and update patterns before introducing new ones
- Reuse existing helper functions
- Do not remove fields or constructors unless required
- Avoid unnecessary renaming
- Keep imports tidy and minimal
- Do not introduce placeholder implementations
- Update all call sikeytes

## UI conventions
- This project uses elm-ui
- Prefer existing spacing, typography, and attribute helper patterns
- Reuse existing view helpers before creating new ones

## JSON conventions
- Use explicit decoders and encoders
- Match existing decoder style in the codebase
- Prefer readable pipeline-style or map-style decoders consistent with nearby code
- Do not silently make fields optional unless the API requires it

## Refactoring rules
- Make the smallest change that solves the task
- Preserve public function names unless explicitly asked
- When changing types, update all affected call sites
- Prefer compiler-guided refactors

## Safety checks
Before finishing:
1. Check for type mismatches
2. Check imports
3. Check pattern matches for exhaustiveness
4. Check that view/update/init stay consistent
5. Run relevant automated checks when available. If tests exist, they should pass before closing the task or suggesting a commit. If a check cannot be run, state that clearly and explain why.

## Commit messages
- After approved file changes, suggest a git commit message that reflects all changes since the last commit.
- Base the suggestion on the current diff against `HEAD`, not only the most recent edit.
- If the working tree contains unrelated changes, say so before suggesting a commit message.
- Prefer short imperative commit messages.
- Prefix commit messages with a change type such as `Feature:`, `Refactor:`, `Style:`, `Documentation:`, `Fix:`, or `Chore:`.

## Priorities
- Clarity over cleverness
- Small, readable modules
- Predictable state transitions
- Simple, polished UX
- Strong type safety
- Minimal dependencies

## When implementing features
- Prefer obvious code over abstract code
- Keep naming concrete and descriptive
- Handle edge cases explicitly
- Avoid overengineering
- Make it easy for a reviewer to follow the flow

## UI Style Guide

This project intentionally follows a design style of calm, refined, minimal, and human.  
The UI should feel like a premium product page rather than a dashboard or demo app.

When making UI changes, maintain the following rules.

---

### Core principles

1. **Calm over clever**
2. **Whitespace over density**
3. **Subtlety over decoration**
4. **Clarity over novelty**
5. **Consistency over variety**

If unsure between two approaches, choose the **simpler and more restrained** option.

---

### Colour

Prefer warm neutral tones.

Good:
- off-white
- stone
- sand
- light grey
- charcoal
- muted earth tones

Avoid:
- bright colours
- saturated accents
- loud gradients
- dark “developer dashboard” themes

Backgrounds should feel **soft and warm**, not stark.

---

### Typography

Typography should feel **editorial and composed**.

Rules:
- modest heading sizes
- minimal weight variation
- comfortable line spacing
- avoid loud typography

Avoid:
- oversized headings
- heavy font weights everywhere
- compressed UI text blocks

---

### Spacing

Whitespace is a defining part of the aesthetic.

Rules:
- prefer generous spacing
- keep layout breathable
- align elements cleanly
- maintain consistent spacing rhythms

Avoid:
- cramped layouts
- dense UI blocks
- tightly packed controls

---

### Components

UI components should feel **quiet and tactile**.

Buttons:
- understated
- soft borders or fills
- not overly rounded
- no bright colours

Panels/cards:
- minimal containers
- subtle separation
- avoid heavy shadows

Inputs:
- clean and accessible
- not visually heavy

---

### Motion

Motion should be **rare and subtle**.

Allowed:
- small hover changes
- gentle transitions

Avoid:
- bouncing animation
- flashy motion
- decorative transitions

---

### Accessibility

Always maintain:

- keyboard navigation
- visible focus states
- readable contrast
- clear interactive controls

Never sacrifice usability for aesthetics.

---

### Implementation rules

When editing UI code:

- keep styling consistent with existing elements
- reuse existing spacing and layout patterns
- prefer simple layout logic
- avoid adding new styling systems or frameworks
- do not introduce flashy UI styles

Optimise for **readability, calmness, and polish**.

---

### AI agent instructions

If modifying UI:

- preserve the existing aesthetic
- keep visual changes minimal
- do not introduce bright colours or heavy styling
- avoid dashboard-style interfaces
- favour whitespace and restraint
- assume the UI will be reviewed for design taste

Prefer solutions that are **simpler, quieter, and more refined**.
