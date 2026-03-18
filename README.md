# Fitzbeach

A small Elm application with a restrained main menu and two pages: a `Motorcycle` product-style landing page and a `Robot` page with the existing 5x5 robot game.

## Features

- Minimal main navigation with `Motorcycle` and `Robot` pages
- Responsive shell layout that adapts navigation, spacing, and page composition for narrower screens
- `Motorcycle` landing page with a restrained product-style panel grid that simulates products arriving over time
- 5x5 robot grid rendered with `elm-ui`
- Robot movement constrained to the grid bounds
- Button controls for move, turn left, turn right, undo, and reset
- Keyboard controls for up, left, and right arrow keys on the `Robot` page
- In-memory command history with the most recent action highlighted
- ElmBook-powered component and page documentation with the same palette as the main app

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

Start the ElmBook documentation app:

```bash
npm run book
```

Create a production build:

```bash
npm run build
```

Create a production ElmBook build:

```bash
npm run book:build
```

Run the unit tests:

```bash
npm test
```

Run `elm-review`:

```bash
npm run review
```

Apply safe automatic review fixes:

```bash
npm run review:fix
```

Run the deploy checks and production build:

```bash
npm run predeploy
```

Publish the current `dist/` output to GitHub Pages:

```bash
npm run deploy
```

`npm run deploy` uses `gh-pages -d dist` and relies on the `predeploy` script to run tests, `elm-review`, and the production build first.

## Design notes

The interface aims for a calm, low-noise presentation. The default light theme uses a restrained white and soft-grey palette, with very light grey panels, dark grey text, and a darker accent for the robot itself. The Motorcycle page uses a quiet product-panel grid inspired by Bellroy collection layouts and now simulates a remote collection feed by progressively revealing products over time, while spacing, borders, and controls remain intentionally understated to keep the interaction readable without feeling bare. On narrower screens the shell reduces padding, stacks the header controls, wraps the robot actions, and scales the board and cards down to avoid horizontal overflow.

The ElmBook catalogue follows the same theme language. Its chrome uses the app palette rather than ElmBook's default blues, and the documented chapters render using the same light and dark theme state used by the main UI.

## Architecture notes

- `src/Main.elm` owns application state, subscriptions, and top-level message routing.
- `src/Book.elm` is a separate ElmBook entrypoint for documented UI examples.
- `src/Book/` contains ElmBook fixtures and chapters.
- `book.js` boots the compiled ElmBook app into `#app`.
- `book.html` is the minimal HTML shell for the ElmBook catalogue.
- `src/Motorcycle/Page.elm` contains the Motorcycle page UI.
- `src/Robot/Model.elm` contains the robot domain model and movement rules.
- `src/Robot/Logic.elm` contains robot command parsing, history handling, and command application.
- `src/Robot/View.elm` contains the robot page UI and board rendering.
- `src/View.elm` contains the shared application shell and page-level view composition.
- `src/View/ThemeToggle.elm` contains the reusable theme toggle component shared by the app and ElmBook.
- `src/View/Theme.elm` centralises the shared color palette.
- `tests/` mirrors the source namespaces with focused Elm unit tests for main app state, view helpers, robot movement, robot command behavior, and theme helpers.

The boundary between domain and UI is deliberate: movement logic stays in the domain module, while the app layer handles input and presentation concerns such as command history.

## Why Elm

Elm is a good fit for a small interactive exercise like this because it keeps state transitions explicit, makes invalid states harder to represent, and supports refactoring with strong compiler feedback. For a constrained problem, that helps keep the implementation small and predictable.

## Possible future enhancements

- Persist command history between sessions
- Add direct placement controls for the robot
- Add automated Elm tests around robot movement and update behavior
- Improve keyboard accessibility cues in the UI
