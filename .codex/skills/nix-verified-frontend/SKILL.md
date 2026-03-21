---
name: "nix-verified-frontend"
description: "Use when tasks involve frontend or static-app projects that use Nix flakes or dev shells to pin tooling, run a canonical verification command, and keep local, CI, and deploy workflows aligned."
---

# Nix Verified Frontend Skill

## When to use
- Add or maintain Nix-based tooling for a frontend or static app.
- Standardize a frontend project's final verification command around `nix develop -c ...`.
- Align local development, CI, and deploy workflows around the same pinned toolchain.
- Debug drift between direct package-manager commands and the project's Nix-based validation path.
- Document how contributors should use a flake dev shell, `direnv`, or pinned verification commands.

Use alongside framework-specific skills when application code is changing.
Use alongside `readme-sync` when setup, verification, or contributor workflow changes.

## When not to use
- When the repository does not use Nix flakes or dev shells and the task does not introduce them.
- When the task is limited to app code with no tooling, CI, or verification workflow impact.
- When deployment and verification are outside the scope of the request.

## Workflow
1. Inspect the Nix entrypoints first.
   - Read `flake.nix`, `.envrc`, CI workflows, and package scripts together.
   - Identify the canonical dev shell and the canonical verification command.
2. Keep one final verification path.
   - Allow direct `npm`, `pnpm`, or other commands for intermediate work if the project does.
   - Reserve one pinned Nix command as the required final validation step.
3. Keep local, CI, and deploy workflows aligned.
   - The same verification command should be usable locally and in CI whenever possible.
   - Deploy steps should build on top of that verification path rather than bypassing it.
4. Keep the dev shell focused.
   - Pin only the tools the project actually needs.
   - Prefer explicit, reproducible tooling over ad hoc global dependencies.
5. Treat docs as part of the workflow.
   - README, AGENTS, and CI descriptions should all match the real Nix-based commands.
   - If `direnv` is supported, document it as optional convenience rather than a requirement unless the project demands it.
6. Re-validate after workflow changes.
   - Re-run the pinned verification command after changing scripts, flake inputs, or CI/deploy wiring.

## Fixing guidance
- Prefer a dedicated script such as `verify` for the project's full validation suite.
- Prefer `nix develop -c <verify-command>` as the final, reproducible check.
- Keep deploy-specific scripts layered on top of verification rather than duplicating it.
- Letting CI use a different toolchain or command sequence than local verification.
- Treating direct package-manager commands as equivalent to the pinned Nix validation path when the project says otherwise.
- Expanding the dev shell with unnecessary tools that the repo does not actually use.
- Forgetting to update docs when the canonical Nix command changes.
- Use the project's actual command names, but prefer the Nix-wrapped verification command when confirming the final state.

## Final checks
- The project has a clear canonical verification command under Nix.
- Local instructions, CI, and deploy workflow all point at the same pinned validation path.
- Relevant validation has been run with the Nix-wrapped verification command, such as `nix develop -c npm run verify`, when appropriate.
- Any inability to run the Nix-based verification step is stated clearly.
