# Robot

A small Elm application that presents a robot on a 5x5 grid with simple movement controls, a restrained interface, and a deliberately small codebase.

## Features

- 5x5 robot grid rendered with `elm-ui`
- Robot movement constrained to the grid bounds
- Button controls for move, turn left, turn right, undo, and reset
- Single theme toggle with sun and moon icon states
- Keyboard controls for up, left, and right arrow keys
- In-memory command history with the most recent action highlighted

## Tech stack

- Elm
- `mdgriffith/elm-ui`
- Parcel

## Run locally

Prerequisites:

- Node.js
- npm

Install dependencies:

```bash
npm install
```

Start the development server:

```bash
npm run dev
```

Create a production build:

```bash
npm run build
```

Run the unit tests:

```bash
npm test
```

## Design notes

The interface aims for a calm, low-noise presentation. The default light theme uses soft neutrals with a darker accent for the robot itself, and the dark theme follows the same restrained structure. Spacing, borders, and controls are intentionally understated to keep the interaction readable without feeling bare.

## Architecture notes

- `src/Robot.elm` contains the robot domain model and movement rules.
- `src/Main.elm` owns application state, user input, and UI composition.
- `src/View/Grid.elm` contains the grid and board rendering.
- `src/View/Theme.elm` centralises the small shared color palette.
- `tests/` contains focused Elm unit tests for robot movement, update behavior, and theme helpers.

The boundary between domain and UI is deliberate: movement logic stays in the domain module, while the app layer handles input and presentation concerns such as command history.

## Why Elm

Elm is a good fit for a small interactive exercise like this because it keeps state transitions explicit, makes invalid states harder to represent, and supports refactoring with strong compiler feedback. For a constrained problem, that helps keep the implementation small and predictable.

## Possible future enhancements

- Persist command history between sessions
- Add direct placement controls for the robot
- Add automated Elm tests around robot movement and update behavior
- Improve keyboard accessibility cues in the UI
