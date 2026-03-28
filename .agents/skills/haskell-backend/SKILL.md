# Haskell Backend Skill

## When to use

- Add or modify the Haskell backend under `backend/`.
- Change Servant routes, response types, handlers, or middleware.
- Update the Stack, Cabal, or Docker setup for the backend.
- Add or adjust backend smoke tests under `backend/test/`.

Use alongside `fixing` for backend regressions and alongside `readme-sync` when backend commands or workflow docs change.

## When not to use

- When the task is limited to Elm, Parcel, or GitHub Pages frontend work.
- When the task is purely AWS infrastructure or deploy automation without backend code or packaging changes.
- When the task is only repo-local skill authoring; use the shared `skill-authoring` skill instead.

## Workflow

1. Inspect the backend entrypoints and package shape first.
   - Read `backend/fitzbeach-backend.cabal`, `backend/stack.yaml`, and the relevant files under `backend/app/`, `backend/src/`, and `backend/test/`.
   - Check `package.json` for the repo-facing backend commands.
2. Follow the current backend structure.
   - Keep HTTP API types in `backend/src/Api.hs`.
   - Keep reusable WAI and server wiring in `backend/src/BackendApp.hs`.
   - Keep `backend/app/Main.hs` thin so it only handles process startup concerns.
   - Keep domain data modules such as `Product` and `ProductSource` separate from transport wiring.
3. Prefer the direct local Stack workflow.
   - Use commands such as `stack --stack-yaml backend/stack.yaml build`, `run`, `ghci`, and `test`.
   - Prefer direct local commands over Nix unless the user explicitly asks for Nix or CI-parity validation.
4. Keep backend tests in process when possible.
   - Prefer `hspec-wai` smoke tests in `backend/test/` over shelling out to a background server for routine endpoint coverage.
   - If response bodies are asserted, use explicit JSON decoding rather than raw string comparisons when practical.
5. Treat Cabal and Docker together.
   - When adding new backend components or source directories, keep `backend/fitzbeach-backend.cabal` and `backend/Dockerfile` aligned.
   - Remember that Cabal component metadata can require test sources to exist in the Docker build context even for executable-only installs.
6. Re-run the relevant backend checks after meaningful edits.
   - Prefer `stack --stack-yaml backend/stack.yaml test` for backend behavior changes.
   - Run `npm run verify` before finishing when the task is substantive.

## Fixing guidance

- Prefer the smallest backend diff that preserves the current route shapes and JSON contracts unless the request explicitly changes them.
- When adding or changing routes, update the API type, server wiring, and smoke tests together.
- When changing response records used in tests, add both `ToJSON` and `FromJSON` instances if the test suite decodes them.
- Keep Stack and Cabal commands explicit to the backend path instead of relying on ambient defaults.
- If Docker or CI breaks after backend packaging changes, check `backend/Dockerfile`, Cabal component declarations, and copied source directories together before changing application code.

## Final checks

- The backend source layout still follows the current `Api` and `BackendApp` split.
- `stack --stack-yaml backend/stack.yaml test` has been run for backend logic or HTTP changes, or any inability to run it is stated clearly.
- `npm run verify` has been run for substantive repo work, or any inability to run it is stated clearly.
- Cabal, Stack, and Docker files remain aligned with the backend source tree.
