# Fitzbeach

A small Elm application with a restrained main menu and two pages: a `Motorcycle` product-style landing page backed by a local Haskell service for development, and a `Robot` page with the existing 5x5 robot game.

Live site: https://genthaler.github.io/fitzbeach/

## Features

- Minimal main navigation with `Motorcycle` and `Robot` pages
- Responsive shell layout that adapts navigation, spacing, and page composition for narrower screens
- `Motorcycle` landing page that loads a restrained product panel grid from a local Haskell JSON API during development
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

- Nix

Optional direct tool setup:

- Node.js
- npm
- Stack

Optional Nix setup:

```bash
nix develop
```

The dev shell provides pinned versions of Node.js, Elm, `elm-test`, and `elm-review`. Direct `npm` commands remain available for intermediate work, but the required final verification step for this repo is:
The dev shell provides pinned versions of Node.js, Elm, `elm-test`, `elm-review`, and Stack. Direct `npm` commands remain available for intermediate work, but the required final verification step for this repo is:

```bash
nix develop -c npm run verify
```

If you use `direnv`, this repo also includes an `.envrc` so entering the directory can load the flake shell automatically after `direnv allow`.

Install frontend dependencies:

```bash
npm install
```

Build the local Haskell product service:

```bash
npm run backend:build
```

Start the local Haskell product service:

```bash
npm run backend:run
```

Open the backend in GHCi for local iteration:

```bash
npm run backend:ghci
```

Then run the server from the GHCi prompt with:

```haskell
:main
```

That starts the API on `http://localhost:8080`.

Confirm the API is responding:

```bash
curl http://localhost:8080/health
curl http://localhost:8080/products
```

Start the frontend development server from the repo root in a second terminal:

```bash
npm run dev
```

Then open the Parcel app and load the default `Motorcycle` page. It will request products from `http://localhost:8080/products`.

Start the ElmBook documentation app:

```bash
npm run book
```

Create a production build:

```bash
npm run build
```

Create a GitHub Pages production build with the repo path prefix:

```bash
npm run build:pages
```

Create a production ElmBook build:

```bash
npm run book:build
```

Run the full verification suite:

```bash
nix develop -c npm run verify
```

That command runs `npm test`, `npm run review`, and `npm run book:build` inside the pinned Nix shell.

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

`npm run deploy` uses `gh-pages -d dist` and relies on the `predeploy` script to run tests, `elm-review`, and the production build first. ElmBook validation is separate: run `nix develop -c npm run verify` before considering shared UI work complete.
`npm run deploy` uses `gh-pages -d dist` and relies on `predeploy` to run `npm run verify` and then `npm run build:pages`, so the deployed app uses the `/fitzbeach/` GitHub Pages path prefix.

GitHub Actions also runs the same Nix-based verification and deploy path on every push to `master`.
Separate GitHub Actions workflows also check `flake.lock` health on pushes and pull requests, and open a weekly PR to refresh `flake.lock`.
Lockfile update PRs created with the default `GITHUB_TOKEN` do not automatically trigger other workflows; if you want CI on those PRs, rerun or reopen them manually, or switch that workflow to a PAT-backed token.

## Design notes

The interface aims for a calm, low-noise presentation. The default light theme uses a restrained white and soft-grey palette, with very light grey panels, dark grey text, and a darker accent for the robot itself. The Motorcycle page uses a quiet product-panel grid and simulates a remote collection feed by progressively revealing products over time each time the page is shown, while spacing, borders, and controls remain intentionally understated to keep the interaction readable without feeling bare. On narrower screens the shell reduces padding, stacks the header controls, wraps the robot actions, and scales the board and cards down to avoid horizontal overflow.

The ElmBook catalogue follows the same theme language. Its chrome uses the app palette rather than ElmBook's default blues, and the documented chapters render using the same light and dark theme state used by the main UI.

## Architecture notes

- `src/Main.elm` owns application state, subscriptions, and top-level message routing.
- `backend/app/Main.hs` starts the local Haskell service and exposes `/health` and `/products`.
- `backend/src/Product.hs` defines the backend `Product` JSON shape shared conceptually with the Elm frontend.
- `backend/src/ProductSource.hs` keeps the current static in-memory product list separate from the HTTP layer so it can be replaced later by DynamoDB or another store.
- `src/Book.elm` is a separate ElmBook entrypoint for documented UI examples.
- `src/Book/` contains ElmBook fixtures and chapters.
- `book.js` boots the compiled ElmBook app into `#app`.
- `book.html` is the minimal HTML shell for the ElmBook catalogue.
- `src/Motorcycle.elm` contains the Motorcycle feature rendering.
- `src/Motorcycle/Api.elm` contains the frontend HTTP request for loading products from the local service.
- `src/Motorcycle/Model.elm` contains the Motorcycle feature product model, JSON decoder, and local sample data used by ElmBook.
- `src/Robot.elm` contains the robot feature state and update orchestration.
- `src/Robot/Model.elm` contains the robot domain model and movement rules.
- `src/Robot/Logic.elm` contains robot command parsing, history handling, and command application.
- `src/Robot/View.elm` contains the robot page UI and board rendering.
- `src/View.elm` contains page selection and rendering for the top-level routes.
- `src/View/Shell.elm` contains the shared application shell, header, navigation, theme toggle placement, and responsive frame layout.
- `src/View/ThemeToggle.elm` contains the reusable theme toggle component shared by the app and ElmBook.
- `src/View/Theme.elm` centralises the shared color palette.
- `tests/` mirrors the source namespaces with focused Elm unit tests for main app state, view helpers, robot movement, robot command behavior, and theme helpers.

The boundary between domain and UI is deliberate: movement logic stays in the domain module, robot feature orchestration lives in the top-level feature module, and the app layer handles routing and subscriptions. The first backend step follows the same approach by keeping the static product source separate from the Haskell HTTP handlers.

## Why Elm

Elm is a good fit for a small interactive exercise like this because it keeps state transitions explicit, makes invalid states harder to represent, and supports refactoring with strong compiler feedback. For a constrained problem, that helps keep the implementation small and predictable.

## Possible future enhancements

- Persist command history between sessions
- Add direct placement controls for the robot
- Add automated Elm tests around robot movement and update behavior
- Improve keyboard accessibility cues in the UI
- Initialize the shell layout from browser viewport flags on startup to avoid a desktop first paint on narrow screens
- Initialize the app theme from the browser's `prefers-color-scheme` media query on startup
