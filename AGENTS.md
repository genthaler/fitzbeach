# AGENTS.md

## Scope

This file defines repo-specific guidance for `fitzbeach`.
Keep it concise and project-specific. Do not use it for generic working style, review habits, or reusable workflow guidance that belongs in skills or user-level `AGENTS.md`.

## Repo Shape

- `frontend/`: Elm app, Parcel entrypoints, ElmBook, review config, and frontend tests
- `backend/`: Haskell backend, Stack config, Cabal file, Dockerfile, and codegen
- `aws/`: CloudFormation, AWS helper scripts, and deploy or publish workflow
- `package.json`: root orchestration across workspaces

Important frontend entrypoints:
- `frontend/src/Main.elm`
- `frontend/src/Book.elm`
- `frontend/index.js`
- `frontend/index.html`
- `frontend/book.js`
- `frontend/book.html`

## Project Conventions

- Preserve compilability whenever practical.
- `frontend/index.js` must continue to initialize `Elm.Main`.
- `frontend/book.js` must continue to initialize `Elm.Book`.
- Keep the app and ElmBook mounted into `<div id="app"></div>`.
- Keep Elm dependencies intentional and minimal.
- Keep the Elm frontend and Haskell backend in sync.
  When backend routes, JSON payloads, or API assumptions change, update the Elm client, decoders, tests, and relevant docs in the same change.
- Keep Elm tests in the matching namespace under `frontend/tests/`.
  The test for a module should be in the same namespace as the tested module.
- Keep the ElmBook catalogue visually aligned with the same calm presentation as the main app.

## Deploy And Verification

- Prefer project scripts and direct local commands over `nix develop` for normal day-to-day work.
- Treat `flake.nix` as the pinned CI-parity path, not the default local workflow.
- Treat `.tool-versions` as an optional local toolchain path, and keep versions aligned with `flake.nix` when intentionally changing shared tools such as Node.js or Stack.
- For local verification, prefer `npm run verify` plus any narrower direct checks that fit the change.
- If Nix is used, treat it as an explicit CI-parity or pinned-environment choice.
- Do not add AWS deploy tooling to `flake.nix` unless the user explicitly asks for that complexity.

Current repo commands:
- `npm run dev`
- `npm run verify`
- `npm run -w frontend book`
- `npm run -w frontend build`
- `npm run -w frontend book:build`
- `npm run -w frontend test`
- `npm run -w frontend review`
- `npm run -w frontend review:fix`
- `npm run -w aws build`
- `npm run -w aws build:pages`
- `npm run -w aws deploy`

GitHub Pages in this repo is only the redirect page, not the main frontend deployment.
- `frontend/redirect.html` is the redirect template.
- `npm run -w aws build:pages` builds the redirect output into `frontend/dist`.
- `npm run -w aws deploy` publishes the redirect after the deployed CloudFront URL is known.

## Skills

Prefer repo-local skills when the task clearly matches them, especially:
- `elm`
- `elm-ui`
- `elmbook`
- `elm-parcel-app`
- `elm-review`
- `haskell-backend`
- `aws-static-lambda`
- `nix-verified-frontend`
- `ui-review`
- `elm-ui-review`

When adding a new repo-local skill:
- also create `agents/openai.yaml`
- keep `SKILL.md` section order as: title, when to use, when not to use, workflow, fixing guidance, final checks
- do not use YAML frontmatter in `SKILL.md`
- keep the skill self-contained and repo-specific

## UI Style

The visual direction is calm, refined, minimal, and human.
The app should feel more like a premium product page than a dashboard.

Prefer:
- restrained white and soft-grey surfaces
- modest heading sizes and comfortable spacing
- subtle separation instead of heavy shadows
- simple layout logic and consistent spacing rhythms

Avoid:
- bright or saturated accents
- loud gradients
- cramped layouts
- flashy motion
- dark dashboard styling

Preserve accessibility:
- keyboard navigation
- visible focus states
- readable contrast
- clear interactive controls

## Git And Finish

- Treat `main` as PR-only.
- Before committing new work, use a branch whose name starts with `codex/` unless the user explicitly asks otherwise.
- Default to a ready PR unless the user explicitly asks for a draft.
