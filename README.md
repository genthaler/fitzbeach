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
- Haskell
- `mdgriffith/elm-ui`
- Parcel
- AWS CloudFormation
- AWS Lambda container images
- S3 + CloudFront

## Run locally

Prerequisites:

- Node.js
- npm
- Stack

Optional Nix setup:

```bash
nix develop
```

The dev shell provides pinned versions of Node.js, Elm, `elm-test`, `elm-review`, and Stack. Direct `npm` commands remain available for intermediate work, but the required final verification step for this repo is:

```bash
nix develop -c npm run verify
```

If you use `direnv`, this repo also includes an `.envrc` so entering the directory can load the flake shell automatically after `direnv allow`.

The Nix shell stays focused on app verification and local development. The AWS deploy path intentionally uses your normal `aws`, `docker`, and shell environment rather than adding those tools to the flake.

The pinned verification path for this repo is still `nix develop -c npm run verify`, and GitHub Actions runs that path in CI. If local disk pressure makes Nix impractical on your machine, use the direct commands below for day-to-day work and rely on CI for the canonical Nix-backed verification pass.

Install frontend dependencies:

```bash
npm install
```

Build the local Haskell product service:

```bash
npm run backend:build
```

Or directly with Stack:

```bash
stack --stack-yaml backend/stack.yaml build
```

Start the local Haskell product service:

```bash
npm run backend:run
```

Or directly with Stack:

```bash
stack --stack-yaml backend/stack.yaml run
```

Restart the backend automatically when Haskell files change:

```bash
npm run backend:watch
```

Or directly with Stack:

```bash
stack --stack-yaml backend/stack.yaml build --file-watch --exec fitzbeach-backend
```

Open the backend in GHCi for local iteration:

```bash
npm run backend:ghci
```

Or directly with Stack:

```bash
stack --stack-yaml backend/stack.yaml ghci
```

Then run the server from the GHCi prompt with:

```haskell
:main
```

Or start the server directly through GHCi in one command:

```bash
npm run backend:ghci:main
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

To run both frontend and backend watch processes together:

```bash
npm run dev:all
```

That command uses `concurrently` to start both processes and stop the other one if either side exits with an error.

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

If you prefer not to enter the Nix shell first, use:

```bash
nix develop -c sh -lc 'npm run verify'
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

`npm run deploy` uses `gh-pages -d dist` and relies on the `predeploy` script to run tests, `elm-review`, and the production build first. ElmBook validation is separate: run `nix develop -c npm run verify` before considering shared UI work complete.
`npm run deploy` uses `gh-pages -d dist` and relies on `predeploy` to run `npm run verify` and then `npm run build:pages`, so the deployed app uses the `/fitzbeach/` GitHub Pages path prefix.

If you are skipping the local Nix shell because of disk constraints, the closest direct equivalent is:

```bash
npm test
npm run review
npm run book:build
```

That is suitable for local iteration, but the Nix-based command in CI remains the canonical reproducible check.

GitHub Actions now keeps Nix health checks separate and uses dedicated AWS deploy and destroy workflows for the CloudFormation-based AWS path.
Separate GitHub Actions workflows also check `flake.lock` health on pushes and pull requests, and open a weekly PR to refresh `flake.lock`.
Lockfile update PRs created with the default `GITHUB_TOKEN` do not automatically trigger other workflows; if you want CI on those PRs, rerun or reopen them manually, or switch that workflow to a PAT-backed token.

## AWS deployment

This repo also includes a container-based AWS deployment path with:

- Elm static assets in a private S3 bucket behind CloudFront
- A Haskell backend deployed as an AWS Lambda container image
- A public Lambda Function URL for `/health` and `/products`
- One CloudFormation template at `infra/template.yaml` for the AWS resources

### AWS prerequisites

- AWS CLI installed and authenticated
- Docker installed and running
- An AWS region selected
- An AWS profile selected if you do not want to use the default profile

The AWS helper scripts read these environment variables:

- `FITZBEACH_AWS_STACK_NAME` for the CloudFormation stack name. Default: `fitzbeach-aws`
- `FITZBEACH_AWS_PROJECT_NAME` for resource naming. Default: `fitzbeach`
- `AWS_REGION` or `FITZBEACH_AWS_REGION` for the AWS region. Default: `ap-southeast-2`
- `AWS_PROFILE` or `FITZBEACH_AWS_PROFILE` for the AWS profile. Optional
- `FITZBEACH_AWS_IMAGE_TAG` to override the backend image tag during deploy. Optional
- `FITZBEACH_API_BASE_URL` to override the frontend API base URL during `aws:frontend:build`. Optional

Example setup:

```bash
export AWS_REGION=ap-southeast-2
export FITZBEACH_AWS_STACK_NAME=fitzbeach-aws
```

### First-time AWS setup

Install frontend dependencies first:

```bash
npm install
```

Validate the CloudFormation template and build the Lambda image locally:

```bash
npm run aws:build
```

Deploy the stack:

```bash
npm run aws:deploy
```

`npm run aws:deploy` performs the first-run bootstrap for the ECR repository automatically, pushes a fresh backend image tag, and then updates the Lambda function to use that image.

`npm run aws:build` uses `aws cloudformation validate-template` before the Docker build, so AWS credentials need to be available even for the validation step.

### Publish the frontend

Build the frontend against the deployed Function URL:

```bash
npm run aws:frontend:build
```

Upload `dist/` to S3 and invalidate CloudFront:

```bash
npm run aws:frontend:publish
```

`npm run aws:frontend:publish` already runs `npm run aws:frontend:build` first, so the publish path is usually the only command you need.

### Find the deployed URLs

Print the stack outputs:

```bash
npm run aws:status
```

That command includes:

- `FrontendUrl` for the CloudFront site
- `BackendFunctionUrl` for the Lambda Function URL
- `FrontendBucketName` for the S3 bucket
- `BackendRepositoryUri` for the ECR repository

### Test the deployed backend

Once the stack is up, use the Function URL from `npm run aws:status`:

```bash
curl "$FUNCTION_URL/health"
curl "$FUNCTION_URL/products"
```

Open the CloudFront URL from `npm run aws:status` to test the deployed frontend.

### Tear everything down

```bash
npm run aws:destroy
```

That command empties the frontend bucket and then deletes the CloudFormation stack.

### GitHub Actions AWS deploy and destroy

The repo includes:

- `.github/workflows/deploy.yml` to verify and deploy on pushes to `master`, and to support manual deploy runs
- `.github/workflows/destroy.yml` for manual teardown runs

These workflows use GitHub OIDC with AWS rather than long-lived access keys.

One-time GitHub setup:

- Create an AWS IAM role that trusts GitHub's OIDC provider for this repository
- Grant that role permission for CloudFormation, Lambda, ECR, S3, CloudFront, and IAM role creation for this stack
- Add the role ARN as the repository secret `AWS_DEPLOY_ROLE_ARN`
- Optionally add repository variables:
  - `AWS_REGION`
  - `FITZBEACH_AWS_STACK_NAME`
  - `FITZBEACH_AWS_PROJECT_NAME`

Workflow behavior:

- The deploy workflow runs `npm ci`, `npm run verify`, `npm run aws:deploy`, and `npm run aws:frontend:publish`
- The destroy workflow is manual-only and runs `./scripts/aws-destroy.sh`
- Both workflows use the same shell scripts as local development so the CI path stays aligned with local commands

## Design notes

The interface aims for a calm, low-noise presentation. The default light theme uses a restrained white and soft-grey palette, with very light grey panels, dark grey text, and a darker accent for the robot itself. The Motorcycle page uses a quiet product-panel grid and simulates a remote collection feed by progressively revealing products over time each time the page is shown, while spacing, borders, and controls remain intentionally understated to keep the interaction readable without feeling bare. On narrower screens the shell reduces padding, stacks the header controls, wraps the robot actions, and scales the board and cards down to avoid horizontal overflow.

The ElmBook catalogue follows the same theme language. Its chrome uses the app palette rather than ElmBook's default blues, and the documented chapters render using the same light and dark theme state used by the main UI.

## Architecture notes

- `src/Main.elm` owns application state, subscriptions, and top-level message routing.
- `backend/app/Main.hs` starts the Haskell service, exposes `/health` and `/products`, and can run both locally and inside the Lambda container.
- `backend/src/Product.hs` defines the backend `Product` JSON shape shared conceptually with the Elm frontend.
- `backend/src/ProductSource.hs` keeps the current static in-memory product list separate from the HTTP layer so it can be replaced later by DynamoDB or another store.
- `backend/Dockerfile` builds the Lambda-compatible backend container image.
- `infra/template.yaml` defines the ECR repository, Lambda Function URL, private frontend bucket, and CloudFront distribution for CloudFormation-based AWS deployment.
- `src/Book.elm` is a separate ElmBook entrypoint for documented UI examples.
- `src/Book/` contains ElmBook fixtures and chapters.
- `book.js` boots the compiled ElmBook app into `#app`.
- `book.html` is the minimal HTML shell for the ElmBook catalogue.
- `src/Motorcycle.elm` contains the Motorcycle feature rendering.
- `src/Motorcycle/Api.elm` contains the frontend HTTP request for loading products from the configured backend base URL.
- `src/Motorcycle/Model.elm` contains the Motorcycle feature product model, JSON decoder, and local sample data used by ElmBook.
- `src/Robot.elm` contains the robot feature state and update orchestration.
- `src/Robot/Model.elm` contains the robot domain model and movement rules.
- `src/Robot/Logic.elm` contains robot command parsing, history handling, and command application.
- `src/Robot/View.elm` contains the robot page UI and board rendering.
- `src/View.elm` contains page selection and rendering for the top-level routes.
- `src/View/Shell.elm` contains the shared application shell, header, navigation, theme toggle placement, and responsive frame layout.
- `src/View/ThemeToggle.elm` contains the reusable theme toggle component shared by the app and ElmBook.
- `src/View/Theme.elm` centralises the shared color palette.
- `scripts/aws-*.sh` keep the AWS build, deploy, publish, status, and teardown flow readable from `package.json`.
- `.github/workflows/` contains Nix health, AWS deploy, AWS destroy, and lockfile maintenance workflows.
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
