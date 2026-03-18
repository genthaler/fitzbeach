# AGENTS.md

## Project

- Name: `fitzbeach`

## Stack
- Elm
- `mdgriffith/elm-ui`
- Parcel

## Project Scope

This file defines repo-specific rules for `fitzbeach`.
General Elm workflow, TEA refactoring habits, and `elm-ui` editing guidance should come from the active Elm skill.

## Goals
- Keep this project minimal and easy to iterate on
- Preserve compilability at all times when possible

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

- Keep the Parcel setup simple.
- `index.js` should continue to initialise `Elm.Main`.
- The app mounts into `<div id="app"></div>` in `index.html`.
- If Elm dependencies are added later, keep them intentional and minimal.

## Commands

- Install JS dependencies: `npm install`
- Start dev server: `npm run dev`
- Build production bundle: `npm run build`

## UI Style Guide

This project intentionally follows a design style of calm, refined, minimal, and human.
The UI should feel like a premium product page rather than a dashboard or demo app.

### Core principles

1. Calm over clever
2. Whitespace over density
3. Subtlety over decoration
4. Clarity over novelty
5. Consistency over variety

If unsure between two approaches, choose the simpler and more restrained option.

### Colour

Prefer a restrained white and soft-grey palette for the default light theme.

Good:
- white for the main app background
- very light grey for panels and quiet surfaces
- dark grey for primary text
- soft neutral greys for borders and secondary text

Avoid:
- bright colours
- saturated accents
- loud gradients
- dark “developer dashboard” themes

Backgrounds should feel clean and quiet, not stark or heavy.

### Typography

Typography should feel editorial and composed.

Rules:
- modest heading sizes
- minimal weight variation
- comfortable line spacing
- avoid loud typography

Avoid:
- oversized headings
- heavy font weights everywhere
- compressed UI text blocks

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

### Components

UI components should feel quiet and tactile.

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

### Motion

Motion should be rare and subtle.

Allowed:
- small hover changes
- gentle transitions

Avoid:
- bouncing animation
- flashy motion
- decorative transitions

### Accessibility

Always maintain:
- keyboard navigation
- visible focus states
- readable contrast
- clear interactive controls

Never sacrifice usability for aesthetics.

### Implementation rules

When editing UI code:
- keep styling consistent with existing elements
- reuse existing spacing and layout patterns
- prefer simple layout logic
- avoid adding new styling systems or frameworks
- do not introduce flashy UI styles

Optimise for readability, calmness, and polish.

## Safety checks

Before finishing:
1. Check that repo-specific structure and bootstrapping remain consistent.
2. Run relevant automated checks when available. If a check cannot be run, state that clearly and explain why.
3. Update `README.md` when the change affects app behaviour, setup, controls, or structure.

## Commit messages

- After approved file changes, suggest a git commit message that reflects all changes since the last commit.
- Base the suggestion on the current diff against `HEAD`, not only the most recent edit.
- If the working tree contains unrelated changes, say so before suggesting a commit message.
- Prefer short imperative commit messages.
- Prefix commit messages with a change type such as `Feature:`, `Refactor:`, `Style:`, `Documentation:`, `Fix:`, or `Chore:`.
