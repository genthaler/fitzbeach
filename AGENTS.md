# AGENTS.md

## Project

- Name: `fitzbeach`

## Scope

This file defines repo-specific rules for `fitzbeach`.
Use the local project skills for general Elm, `elm-review`, `elm-ui`, Parcel app, README maintenance, and git workflow guidance.

## Structure

- `src/Main.elm`: Elm entry point and UI
- `index.js`: boots the compiled Elm app into `#app`
- `index.html`: minimal HTML shell for Parcel
- `package.json`: JS tooling only

## Project Rules

- Keep this project minimal and easy to iterate on.
- Preserve compilability at all times when possible.
- `index.js` should continue to initialise `Elm.Main`.
- The app mounts into `<div id="app"></div>` in `index.html`.
- If Elm dependencies are added later, keep them intentional and minimal.

## Commands

- Install JS dependencies: `npm install`
- Start dev server: `npm run dev`
- Build production bundle: `npm run build`
- Run tests: `npm test`
- Run review checks: `npm run review`
- Apply review autofixes: `npm run review:fix`
- Run deploy prechecks and build: `npm run predeploy`
- Publish `dist/` to GitHub Pages: `npm run deploy`

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

## Skills

### Available local skills

- `elm`: General Elm application and refactor work.
- `elm-review`: `elm-review` runs, rule fixes, and review config maintenance.
- `elm-ui`: `mdgriffith/elm-ui` layout and styling work.
- `elm-ui-review`: Calm, minimal `elm-ui` presentation review.
- `elm-parcel-app`: Parcel bootstrapping and Elm app integration.
- `readme-sync`: Keep `README.md` aligned with app behavior and commands.
- `git`: Git status, diff review, and commit message guidance.
