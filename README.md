# Fitzbeach

A small Elm application with a restrained main menu and two pages: a `Motorcycle` product-style landing page backed by a local Haskell service for development, and a `Robot` page with the existing 5x5 robot game.

Live site: the AWS frontend. `https://genthaler.github.io/fitzbeach/` redirects there.

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

That split is deliberate: AWS CLI is easier to manage through your normal shell tooling or GitHub Actions setup, and Docker in CI depends on the runner's daemon/runtime anyway, so pinning those tools in Nix would add complexity without giving the same payoff as pinning the app verification toolchain.

The pinned verification path for this repo is still `nix develop -c npm run verify`, and GitHub Actions runs that path in CI. If local disk pressure makes Nix impractical on your machine, use the direct commands below for day-to-day work and rely on CI for the canonical Nix-backed verification pass.

Tooling split:

- `.tool-versions` is an optional local `asdf` path for contributors who manage tools that way
- `flake.nix` is the CI and pinned verification path
- repo-local Codex skills live under `.agents/skills/`, following the documented repository skill layout
- For tools shared by both, such as Node.js and Stack, keep the versions aligned where practical

Local tool installation and version management remain the responsibility of the developer. This repo does not require `asdf`; `.tool-versions` is provided only as a convenience for contributors who already use it.

Repo-facing backend npm scripts use a backend-local Stack root at `backend/.stack-root/`, so Stack state stays inside the backend workspace area and out of the repo root.

Git workflow note: `main` is protected and PR-only. New changes should land from a branch via pull request rather than direct commits or pushes to `main`.

Install frontend dependencies:

```bash
npm install
```

The repo root now uses npm workspaces. The `frontend/` workspace owns the Parcel and Elm toolchain, while the root `package.json` keeps the repo-facing commands such as `npm run dev`, `npm run build`, and `npm run verify`.

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

## API code generation

Shared Elm transport types are generated from Haskell backend transport types.
The Haskell source of truth for the current generated Elm modules is:

- `backend/src/Product.hs`
- `backend/src/Api.hs` for `HealthResponse`

Generated Elm files are checked in under:

- `frontend/src/Generated/Api/Product.elm`
- `frontend/src/Generated/Api/HealthResponse.elm`

HTTP request orchestration remains handwritten in Elm under `frontend/src/Api/`.

Regenerate the checked-in Elm transport modules from the repo root with:

```bash
npm run api:generate
```

That command runs the dedicated backend codegen executable and overwrites the generated Elm files deterministically.

To check for stale generated files, run:

```bash
npm run api:check-generated
```

`npm run verify` includes that drift check before the Elm and backend test steps, so CI fails if generated Elm is out of date with the backend transport types.

Start the frontend development server from the repo root in a second terminal:

```bash
npm run dev
```

That root command delegates to the `frontend` workspace rather than shelling into `frontend/` manually.

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

Create the GitHub Pages redirect build:

```bash
npm run build:pages
```

That command builds a small redirect page to the deployed AWS frontend. It reads `FrontendUrl` from the current AWS stack unless `FITZBEACH_PAGES_REDIRECT_URL` is set explicitly.

Create a production ElmBook build:

```bash
npm run book:build
```

Run the full verification suite:

```bash
nix develop -c npm run verify
```

That command runs `npm run api:check-generated`, `npm test`, `npm run review`, `npm run backend:test`, and `npm run book:build` inside the pinned Nix shell.

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

Publish the current `frontend/dist/` output to GitHub Pages:

```bash
npm run deploy
```

`npm run deploy` uses `gh-pages -d frontend/dist` and relies on the `predeploy` script to run tests and then build a small redirect page that sends `https://genthaler.github.io/fitzbeach/` to the current AWS frontend URL. ElmBook validation is separate: run `nix develop -c npm run verify` before considering shared UI work complete.

If you are skipping the local Nix shell because of disk constraints, the closest direct equivalent is:

```bash
npm run api:check-generated
npm test
npm run review
npm run backend:test
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
- One CloudFormation template at `aws/infra/template.yaml` for the AWS resources

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

Upload `frontend/dist/` to S3 and invalidate CloudFront:

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

If `aws:status` reports that the stack does not exist, check that your AWS login, account, region, and optional `AWS_PROFILE` point at the same environment used for deploys.

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

- `.github/workflows/deploy.yml` to verify and deploy on pushes to `main`, and to support manual deploy runs
- `.github/workflows/destroy.yml` for manual teardown runs

These workflows use GitHub OIDC with AWS rather than long-lived access keys.

One-time GitHub setup:

- If your AWS account does not already have GitHub's OIDC provider, create it once:

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

- Copy [aws/infra/github-actions-oidc-trust-policy.json](/Users/bonj/Developer/Elm/fitzbeach/aws/infra/github-actions-oidc-trust-policy.json) and replace:
  - `<AWS_ACCOUNT_ID>` with your AWS account ID
  - `<GITHUB_OWNER>` with the GitHub owner or organisation
  - `<GITHUB_REPO>` with this repository name
  - The template trusts `refs/heads/main` only
- Create the GitHub deploy role:

```bash
aws iam create-role \
  --role-name fitzbeach-github-actions-deploy \
  --assume-role-policy-document file://aws/infra/github-actions-oidc-trust-policy.json
```

- If the role already exists, update its assume-role policy from the current template:

```bash
aws iam update-assume-role-policy \
  --role-name fitzbeach-github-actions-deploy \
  --policy-document file://aws/infra/github-actions-oidc-trust-policy.json
```

- Attach the deploy policy from [aws/infra/github-actions-deploy-policy.json](/Users/bonj/Developer/Elm/fitzbeach/aws/infra/github-actions-deploy-policy.json):

```bash
aws iam put-role-policy \
  --role-name fitzbeach-github-actions-deploy \
  --policy-name fitzbeach-github-actions-deploy \
  --policy-document file://aws/infra/github-actions-deploy-policy.json
```

- Add the role ARN as the repository secret:

```text
AWS_DEPLOY_ROLE_ARN=arn:aws:iam::<AWS_ACCOUNT_ID>:role/fitzbeach-github-actions-deploy
```

- Optionally add repository variables:
  - `AWS_REGION`
  - `FITZBEACH_AWS_STACK_NAME`
  - `FITZBEACH_AWS_PROJECT_NAME`

- The example deploy policy is intentionally straightforward rather than tightly minimised.
  For this demo, the priority is deterministic deployment, small diffs, and reviewer readability.
  Tighten it later if you want stricter repository- or stack-scoped permissions.

Validate the trust from GitHub by running the deploy workflow manually after the secret is configured. If OIDC is misconfigured, `aws-actions/configure-aws-credentials` will fail before any deploy step runs.

Workflow behavior:

- The deploy workflow runs `npm ci`, `npm run verify`, `npm run aws:deploy`, and `npm run aws:frontend:publish`
- The destroy workflow is manual-only and runs `./aws/scripts/aws-destroy.sh`
- Both workflows use the same shell scripts as local development so the CI path stays aligned with local commands

Current verification status:

- The GitHub Actions deploy workflow has been exercised successfully against AWS with GitHub OIDC authentication
- The GitHub Actions destroy workflow uses the same role and shell scripts, but has not been exercised in GitHub Actions here because it is intentionally destructive

## Design notes

The interface aims for a calm, low-noise presentation. The default light theme uses a restrained white and soft-grey palette, with very light grey panels, dark grey text, and a darker accent for the robot itself. The Motorcycle page uses a quiet product-panel grid and simulates a remote collection feed by progressively revealing products over time each time the page is shown, while spacing, borders, and controls remain intentionally understated to keep the interaction readable without feeling bare. On narrower screens the shell reduces padding, stacks the header controls, wraps the robot actions, and scales the board and cards down to avoid horizontal overflow.

The ElmBook catalogue follows the same theme language. Its chrome uses the app palette rather than ElmBook's default blues, and the documented chapters render using the same light and dark theme state used by the main UI.

## Architecture notes

- `frontend/src/Main.elm` owns application state, subscriptions, and top-level message routing.
- `backend/app/Main.hs` starts the Haskell service, exposes `/health` and `/products`, and can run both locally and inside the Lambda container.
- `backend/src/Product.hs` defines the backend `Product` JSON shape shared conceptually with the Elm frontend.
- `backend/src/ProductSource.hs` keeps the current static in-memory product list separate from the HTTP layer so it can be replaced later by DynamoDB or another store.
- `backend/Dockerfile` builds the Lambda-compatible backend container image.
- `aws/infra/template.yaml` defines the ECR repository, Lambda Function URL, private frontend bucket, and CloudFront distribution for CloudFormation-based AWS deployment.
- `frontend/src/Book.elm` is a separate ElmBook entrypoint for documented UI examples.
- `frontend/src/Book/` contains ElmBook fixtures and chapters.
- `frontend/book.js` boots the compiled ElmBook app into `#app`.
- `frontend/book.html` is the minimal HTML shell for the ElmBook catalogue.
- `frontend/src/Motorcycle.elm` contains the Motorcycle feature rendering.
- `frontend/src/Motorcycle/Api.elm` contains the frontend HTTP request for loading products from the configured backend base URL.
- `frontend/src/Motorcycle/Model.elm` contains the Motorcycle feature product model, JSON decoder, and local sample data used by ElmBook.
- `frontend/src/Robot.elm` contains the robot feature state and update orchestration.
- `frontend/src/Robot/Model.elm` contains the robot domain model and movement rules.
- `frontend/src/Robot/Logic.elm` contains robot command parsing, history handling, and command application.
- `frontend/src/Robot/View.elm` contains the robot page UI and board rendering.
- `frontend/src/View.elm` contains page selection and rendering for the top-level routes.
- `frontend/src/View/Shell.elm` contains the shared application shell, header, navigation, theme toggle placement, and responsive frame layout.
- `frontend/src/View/ThemeToggle.elm` contains the reusable theme toggle component shared by the app and ElmBook.
- `frontend/src/View/Theme.elm` centralises the shared color palette.
- `aws/scripts/aws-*.sh` keep the AWS build, deploy, publish, status, and teardown flow readable from `package.json`.
- `.github/workflows/` contains Nix health, AWS deploy, AWS destroy, and lockfile maintenance workflows.
- `frontend/tests/` mirrors the source namespaces with focused Elm unit tests for main app state, view helpers, robot movement, robot command behavior, and theme helpers.

The boundary between domain and UI is deliberate: movement logic stays in the domain module, robot feature orchestration lives in the top-level feature module, and the app layer handles routing and subscriptions. The first backend step follows the same approach by keeping the static product source separate from the Haskell HTTP handlers.

## Possible future enhancements

- Persist command history between sessions
- Add direct placement controls for the robot
- Add automated Elm tests around robot movement and update behavior
- Improve keyboard accessibility cues in the UI
- Initialize the shell layout from browser viewport flags on startup to avoid a desktop first paint on narrow screens
- Initialize the app theme from the browser's `prefers-color-scheme` media query on startup
