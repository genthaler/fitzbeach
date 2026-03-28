# GitHub Pages Static App Skill

## When to use
- Add or maintain GitHub Pages deployment for a static app.
- Configure or debug the GitHub Pages redirect build and publish flow.
- Fix path-prefix issues for apps served from `https://<user>.github.io/<repo>/`.
- Document or review a GitHub Pages release workflow.
- Validate that the published build directory and deploy command are consistent.
- Work on the GitHub Pages deployment target specifically when the repo has other deploy targets as well.

Use alongside framework-specific skills when the app build itself is changing.
Use alongside the shared `readme-sync` skill when deployment instructions or contributor workflow change.

## When not to use
- When the task is limited to app code with no deploy workflow or public-path impact.
- When the deployment target is not GitHub Pages.
- When the task involves the AWS deploy path, CloudFormation, Lambda, S3, CloudFront, or GitHub OIDC workflow; use `aws-static-lambda` instead.
- When the request is only to review UI or domain logic.

## Workflow
1. Inspect the existing deploy path first.
   - Read `aws/package.json`, `aws/scripts/build-pages.mjs`, `aws/scripts/deploy.mjs`, `frontend/redirect.html`, and the relevant README sections.
   - Identify the Pages-specific build output and where the final publish step happens.
   - If the repo also has non-Pages deploy targets, identify which scripts and docs belong only to the GitHub Pages path and avoid mixing them with the other deployment system.
2. Separate normal build concerns from Pages concerns.
   - In this repo, keep the standard frontend build for CloudFront separate from the GitHub Pages redirect build.
   - Do not push AWS frontend deploy concerns into the Pages redirect template or script.
3. Put verification before publishing.
   - Keep the Pages build explicit with `npm run -w aws build:pages`.
   - Keep the publish step thin: publish the already-built redirect output rather than rebuilding ad hoc inside the final `gh-pages` command.
4. Handle path prefixes explicitly.
   - If the site is hosted under a repository subpath, keep the redirect page and published path assumptions explicit.
   - Verify that redirects still work from both the main Pages URL and the generated `404.html` fallback.
5. Keep the publish target explicit.
   - In this repo, the redirect build generates `frontend/dist`.
   - Ensure the `gh-pages` command points at that same directory.
6. Re-check the docs and workflow after changes.
   - README and contributor instructions should describe the actual deploy and verification path, not an approximation.

## Fixing guidance
- Prefer the current split:
  - `npm run -w aws build:pages`: build the redirect page
  - `npm run -w aws deploy`: deploy AWS and publish the Pages redirect
- Keep the redirect template simple and data-driven rather than embedding large inline HTML in the build script.
- Forgetting the repository path prefix, causing broken asset URLs after deploy.
- Publishing the wrong output directory.
- Letting the Pages publish path drift away from the AWS deploy flow where the final CloudFront URL becomes known.
- Mixing GitHub Pages script or documentation changes into a separate deployment path such as the repo's AWS workflow.
- Documenting a deploy flow that does not match the scripts on disk.
- Run the smallest relevant command first, then the full `npm run -w aws deploy` path when validating a release workflow change.

## Final checks
- The deploy workflow clearly separates verification, build, and publish steps.
- Any Pages-specific public URL or base path is intentional and documented.
- The published directory matches the configured build output.
- Relevant validation has been run with commands such as `npm run -w aws build:pages`, `npm run -w aws deploy`, or `npm run verify` as appropriate.
