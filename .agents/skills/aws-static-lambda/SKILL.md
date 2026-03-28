# AWS Static Lambda Skill

## When to use

- Change the AWS deploy flow for this repo.
- Modify CloudFormation resources under `aws/infra/`.
- Update AWS helper scripts under `aws/scripts/aws-*.sh`.
- Change GitHub Actions deploy or destroy workflows for the AWS path.
- Debug issues involving the Lambda container backend, Function URL, S3 frontend bucket, CloudFront distribution, or GitHub OIDC deploy role.

Use alongside the shared `readme-sync` skill when AWS operator instructions change and the shared `fixing` skill when investigating a broken deploy or teardown path.

## When not to use

- When the task is limited to local backend code with no infrastructure or deploy impact.
- When the deployment target is GitHub Pages only; use `github-pages-static-app` instead.
- When the task is purely frontend UI or Elm application work with no AWS workflow changes.

## Workflow

1. Inspect the full AWS path before editing.
   - Read `aws/infra/template.yaml`, the relevant `aws/scripts/aws-*.sh` files, `package.json`, and the AWS workflows under `.github/workflows/`.
   - Check `README.md` for the documented operator flow and environment variables.
2. Preserve the repo's AWS shape unless the request explicitly changes it.
   - Backend runs as a Lambda container image.
   - Backend is exposed through a Lambda Function URL.
   - Frontend assets are published to S3 behind CloudFront.
   - Infrastructure is managed through CloudFormation rather than ad hoc CLI creation.
3. Prefer the normal shell toolchain for AWS work.
   - Use `aws`, `docker`, and the repo's shell scripts directly.
   - Do not move AWS deploy tooling into `flake.nix` unless the user explicitly asks for that complexity.
4. Keep shared AWS configuration centralized.
   - Prefer `aws/scripts/aws-common.sh` for stack name, project name, region, profile, and shared AWS CLI argument handling.
   - Keep script behavior aligned with the environment variables documented in `README.md`.
5. Treat deploy, publish, and destroy flows as one system.
   - If the backend URL or stack outputs change, verify the frontend build and publish path still uses the right API base.
   - If IAM, OIDC, or workflow permissions change, update both the policy documents and the GitHub Actions workflow assumptions together.
6. Be careful with destructive operations.
   - Call out teardown risk when touching `aws/scripts/aws-destroy.sh`, `destroy.yml`, or stack deletion logic.
   - Prefer the smallest change that restores deterministic deploy or destroy behavior.
7. When debugging GitHub Actions deploy failures, separate repo state from live AWS state.
   - Use `gh run list --workflow "AWS Deploy"` and `gh run view <run> --json ...` to identify the failing step before editing.
   - If `Configure AWS credentials` fails, inspect the live IAM OIDC trust policy assumptions, not just the checked-in JSON template.
   - Treat branch renames as a two-part migration: update repo-owned workflow/template/docs changes, then update the live AWS role trust policy.
   - Prefer documenting or templating the AWS-side remediation when the live role is the real blocker and cannot be changed from this repo.

## Fixing guidance

- If deployment fails, inspect the shell script, CloudFormation template, and workflow step ordering together before rewriting resources.
- Prefer validating template or script assumptions with the existing repo commands such as `npm run aws:build`, `npm run aws:deploy`, and `npm run aws:status`.
- Keep CloudFormation templates and shell scripts readable and explicit rather than overly abstract.
- When changing OIDC or IAM-related files, keep policy JSON and workflow usage in sync to avoid half-applied auth changes.
- If a deploy fails with `Not authorized to perform sts:AssumeRoleWithWebIdentity`, assume the live AWS role trust may still be stale even if the checked-in policy file is correct.
- When fixing branch-rename fallout, consider a temporary migration-safe trust policy that allows both the old and new branch refs, then document how to remove the legacy ref once the live role is updated.
- If frontend publishing depends on deployed backend outputs, verify that stack output names and publish scripts still agree.

## Final checks

- The AWS change stays aligned across `aws/infra/`, `aws/scripts/`, workflows, and README where relevant.
- The normal shell-based AWS workflow is still the primary path; Nix has not been expanded into AWS tooling unless explicitly requested.
- Relevant validation has been run with the smallest applicable commands, such as `npm run aws:build`, `npm run aws:deploy`, `npm run aws:status`, or `npm run verify`, or any inability to run them is stated clearly.
- Destructive changes are clearly identified and kept as narrow as possible.
