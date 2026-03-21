# GitHub Pages Static App Skill

## When to use
- Add or maintain GitHub Pages deployment for a static app.
- Configure or debug `build`, `predeploy`, and `deploy` scripts for GitHub Pages.
- Fix path-prefix issues for apps served from `https://<user>.github.io/<repo>/`.
- Document or review a GitHub Pages release workflow.
- Validate that the published build directory and deploy command are consistent.

Use alongside framework-specific skills when the app build itself is changing.
Use alongside `readme-sync` when deployment instructions or contributor workflow change.

## When not to use
- When the task is limited to app code with no deploy workflow or public-path impact.
- When the deployment target is not GitHub Pages.
- When the request is only to review UI or domain logic.

## Workflow
1. Inspect the existing deploy path first.
   - Read `package.json` or equivalent task runner config.
   - Identify the normal production build, any Pages-specific build, and the publish directory.
2. Separate normal build concerns from Pages concerns.
   - Keep the standard production build available for non-Pages environments when possible.
   - Add a dedicated Pages build only when a repository path prefix or other deploy-specific setting is required.
3. Put verification before publishing.
   - Prefer a `predeploy` step that runs the project's required checks before publishing.
   - Keep deploy commands thin: publish the already-built directory rather than rebuilding ad hoc inside the deploy command.
4. Handle path prefixes explicitly.
   - If the site is hosted under a repository subpath, configure the build tool's public/base URL accordingly.
   - Verify that asset URLs and client-side routing assumptions still work under the prefixed path.
5. Keep the publish target explicit.
   - Use a single build output directory such as `dist/`.
   - Ensure the `gh-pages` command points at the same directory the Pages build generates.
6. Re-check the docs and workflow after changes.
   - README and contributor instructions should describe the actual deploy and verification path, not an approximation.

## Fixing guidance
- Prefer a structure like:
  - `build`: normal production build
  - `build:pages`: GitHub Pages build with repository prefix if needed
  - `predeploy`: verification plus the Pages build
  - `deploy`: `gh-pages -d <build-dir>`
- Keep script names conventional unless the project already uses a different pattern.
- Forgetting the repository path prefix, causing broken asset URLs after deploy.
- Publishing the wrong output directory.
- Letting `deploy` bypass tests, lint, or review checks that the project expects.
- Documenting a deploy flow that does not match the scripts on disk.
- Run the smallest relevant command first, then the full predeploy path when validating a release workflow change.

## Final checks
- The deploy workflow clearly separates verification, build, and publish steps.
- Any Pages-specific public URL or base path is intentional and documented.
- The published directory matches the configured build output.
- Relevant validation has been run with commands such as `npm run build`, `npm run build:pages`, `npm run predeploy`, or `npm run deploy` as appropriate.
