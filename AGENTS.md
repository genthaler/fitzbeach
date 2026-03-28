# AGENTS.md

## Project

- Name: `fitzbeach`

## Scope

This file defines repo-specific rules for `fitzbeach`.
Use repo-local skills for project-specific domains such as Elm, the Haskell backend, AWS static and Lambda deployment, `elm-review`, `elm-ui`, ElmBook, GitHub Pages static app deployment, Nix-verified frontend workflow, Parcel app, and UI review.
For generic workflow skills such as git guidance, refactoring, README maintenance, and skill authoring, prefer the shared user-level skills unless this repo has an intentional local override.

## Structure

- `frontend/src/Main.elm`: Elm entry point and UI
- `frontend/src/Book.elm`: ElmBook entry point for the component catalogue
- `frontend/src/Book/`: ElmBook fixtures and chapters
- `frontend/index.js`: boots the compiled Elm app into `#app`
- `frontend/index.html`: minimal HTML shell for Parcel
- `frontend/book.js`: boots the compiled ElmBook app into `#app`
- `frontend/book.html`: minimal HTML shell for the ElmBook catalogue
- `frontend/package.json`: frontend JS, Elm, Parcel, ElmBook, and review tooling
- `backend/package.json`: backend Stack and codegen commands
- `aws/package.json`: AWS deploy, publish, and Pages redirect commands
- `package.json`: root orchestration across workspaces

## Project Rules

- Keep this project minimal and easy to iterate on.
- Preserve compilability at all times when possible.
- `frontend/index.js` should continue to initialise `Elm.Main`.
- The app mounts into `<div id="app"></div>` in `frontend/index.html`.
- `frontend/book.js` should continue to initialise `Elm.Book`.
- The ElmBook catalogue mounts into `<div id="app"></div>` in `frontend/book.html`.
- If Elm dependencies are added later, keep them intentional and minimal.
- Keep the Elm frontend and Haskell backend in sync.
  When changing backend routes, JSON payloads, or API assumptions, update the Elm client, decoders, tests, and relevant docs in the same change.
- Keep the ElmBook catalogue visually aligned with the same palette and calm presentation used by the main app.
- When creating a new project-local skill under `./.agents/skills/`, also create `agents/openai.yaml` for that skill so local skills stay consistent and discoverable.
- When creating or updating a project-local skill, use the shared `skill-authoring` skill.
- Project-local `SKILL.md` files should follow this section order: title, when to use, when not to use, workflow, fixing guidance, final checks.
- Project-local `SKILL.md` files should not use YAML frontmatter; keep skill metadata only in `agents/openai.yaml`.
- Keep shared workflow skills shared when possible. If a project-local skill duplicates a shared skill, keep only the repo-specific delta locally or remove the local fork.
- When a task clearly matches a repo-local skill, reference that skill by name in the prompt rather than rewriting its workflow inline.
- When the user asks to implement a change, prefer the local `implementation` skill as the default workflow and combine it with narrower domain skills only when needed.
- When the user asks to fix a bug, address a finding, or correct a regression, prefer the local `fixing` skill as the default workflow and combine it with narrower domain skills only when needed.
- When the user asks for a review, prefer the local `ui-review` skill for UI-focused review requests and findings-first review workflows.
- When the user asks for a refactor, prefer the shared `refactoring` skill unless the task clearly needs a repo-specific local skill instead.
- When using the task plan tool, prefer short user-visible milestones.
- Update the plan as work progresses, not only at the end.
- Do not keep an inspection or analysis step in progress after the relevant files have been read.
- Mark steps completed one at a time as they finish instead of batch-completing the whole plan at closeout.
- Keep at most one step in progress.
- Separate editing, testing, verification, and commit steps.
- Treat `.tool-versions` as an optional local `asdf` toolchain path and `flake.nix` as the CI and pinned verification path.
- For tools shared by both `.tool-versions` and `flake.nix`, such as Node.js and Stack, keep versions aligned where practical and update both files together when intentionally changing them.
- Do not add AWS deploy tooling to `flake.nix` unless the user explicitly asks for that complexity; prefer the normal shell toolchain for AWS CLI and Docker.
  Reason: AWS CLI is easier to manage through local shell tooling or GitHub Actions setup, and Docker in CI depends on the runner daemon/runtime, so pinning those tools in Nix adds complexity without matching the benefit of pinning the app verification toolchain.
- Local tool installation and version management remain the developer's responsibility; do not imply that `asdf` is required just because `.tool-versions` exists.

## Thread Roles

### Architect

Use for planning, repo exploration, architecture decisions, and acceptance criteria.
Do not implement unless explicitly instructed.

### Builder

Use for implementing approved plans in small validated steps.
Prefer minimal diffs and run relevant checks.

### Fixer

Use for debugging, root-cause analysis, and regression repair.
Prefer reproducing issues before editing.

## Subagent Policy

- Spawn subagents only for bounded work that can run independently in parallel.
- Good fits include codebase exploration, test drafting, edge-case review, and performance or security review.
- Do not spawn subagents for trivial tasks or when a single focused pass is enough.
- Always summarize subagent findings back into the parent thread.

## Commands

- Do not use `nix develop` for normal local development or local verification unless the user explicitly asks for Nix or CI-parity verification.
- Prefer project scripts and direct local commands first for day-to-day work.
- Elm tooling may not be available on the base shell path in this repo. Prefer project scripts first, and if a direct Elm command is needed, use the normal local shell toolchain before considering `nix develop -c ...`.
- `nix develop -c npm run verify` remains the pinned CI verification path, but it is not the default local workflow.
- For local verification, prefer direct commands such as `npm run verify` and `stack --stack-yaml backend/stack.yaml ...`.
- If Nix is used, treat it as an explicit choice for pinned-environment validation rather than a routine prerequisite for local work.
- Install JS dependencies: `npm install`
- Start dev server: `npm run dev`
- Start ElmBook catalogue: `npm run -w frontend book`
- Build production bundle: `npm run -w frontend build`
- Build ElmBook catalogue: `npm run -w frontend book:build`
- Run full verification: `npm run verify`
- Run frontend tests: `npm run -w frontend test`
- Run frontend review checks: `npm run -w frontend review`
- Apply review autofixes: `npm run -w frontend review:fix`
- Validate AWS infra and local image build: `npm run -w aws build`
- Build the GitHub Pages redirect bundle: `npm run -w aws build:pages`
- Deploy AWS and publish the GitHub Pages redirect: `npm run -w aws deploy`

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
2. For local work, run the most appropriate direct verification commands before considering a substantive code task complete, such as `npm run verify` and relevant direct backend checks. Use `nix develop -c npm run verify` only when the user explicitly asks for Nix or when CI-parity validation is specifically needed. If the direct local checks cannot be run, state that clearly and explain why.
3. Before making a repo commit for new work, create or switch to a branch whose name starts with `codex/` unless the user explicitly asks to stay on the current branch.
4. After the task is complete, commit the changes.
5. Treat `main` as PR-only. Do not plan to land changes by committing directly on `main`; push a branch and open a PR instead.
6. When opening a PR, default to a ready PR unless the user explicitly asks for a draft PR.

## Skills

### Workflow defaults

- `implementation`: Default workflow for directed implementation tasks in this repo, keeping prompt overhead low and coordinating narrower skills when needed.
- `fixing`: Default workflow for targeted bug fixes, review findings, and regression corrections in this repo, favouring the smallest defensible change.

### Elm and UI work

- `elm`: General Elm application and refactor work.
- `elm-ui`: `mdgriffith/elm-ui` layout and styling work.
- `elmbook`: ElmBook catalogues, chapters, shared demo state, and theme alignment.
- `elm-parcel-app`: Parcel bootstrapping and Elm app integration.

### Quality and review

- `elm-review`: `elm-review` runs, rule fixes, and review config maintenance.
- `elm-testing`: Add or improve Elm test coverage in this repo, especially around behavior seams, pure helpers, and feature/module contracts.
- `elm-ui-review`: Calm, minimal `elm-ui` presentation review.
- `ui-review`: Findings-first UI review workflow for this repo, prioritising responsiveness, accessibility, regressions, and calm presentation consistency.

### Tooling and platform

- `haskell-backend`: Stack, Cabal, Servant, WAI, Docker, and smoke-test workflow for the Haskell backend.
- `nix-verified-frontend`: Nix dev shells, pinned verify commands, and aligned local/CI/deploy frontend workflows.
- `github-pages-static-app`: GitHub Pages deploy scripts, public path handling, and `gh-pages` publishing for static apps.
- `aws-static-lambda`: CloudFormation, Lambda container, Function URL, S3, CloudFront, AWS shell scripts, and GitHub OIDC deploy workflow for this repo.

### Documentation and repo maintenance

- `readme-sync`: Keep `README.md` aligned with app behavior and commands.
