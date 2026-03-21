---
name: "elm-review"
description: "Use when tasks involve running elm-review, fixing lint or static-analysis violations in Elm projects, maintaining review configuration, or making rule-aware refactors with minimal code churn. Prefer the project's existing review scripts, preserve compilability, and validate with elm-review after changes."
---

# Elm Review Skill

## When to use
- Fix `elm-review` failures in an Elm project.
- Interpret rule violations and apply the smallest coherent code change.
- Update `review/src/ReviewConfig.elm` or the review project under `review/`.
- Add, remove, or tune `elm-review` rules and re-validate the codebase.

Use alongside the `elm` skill when review fixes require non-trivial Elm refactors.
Use alongside the `readme-sync` skill if review commands or contributor workflow change.

## When not to use
- When the task is general Elm implementation work without a review or static-analysis concern.
- When the task is documentation-only and does not affect review config or lint workflow.
- When another skill better fits the main change and `elm-review` only needs a final pass.

## Workflow
1. Inspect the review setup first.
   - Read `package.json` for review scripts.
   - Read `review/src/ReviewConfig.elm` before changing rules or interpreting failures.
   - If present, note directory-specific exceptions such as relaxed rules for `tests/`.
2. Run the smallest relevant review command.
   - Prefer the project's wrapper script, usually `npm run review`.
   - Use auto-fix only when the task allows mechanical edits and the rule is safe to apply broadly.
3. Fix violations with minimal churn.
   - If the task allows mechanical edits, run `npm run review:fix` before applying manual fixes.
   - Prefer local edits over broad rewrites.
   - Preserve public APIs unless the task requires a change.
   - If a rule reveals dead code, remove the dead code and update callers or tests coherently.
4. Treat rule configuration changes as product changes.
   - Do not weaken or disable a rule just to make an error disappear unless the user asked for that tradeoff.
   - Keep exceptions narrow and explicit.
   - When changing rule behavior, explain the reason in code if it is not obvious from the config.
5. Re-run validation after edits.
   - Re-run `npm run review`.
   - Run the next smallest relevant check if review fixes touched behavior, usually `npm test` or the build command.

## Fixing guidance
- `NoUnused.*`: remove the unused code, or thread the value through if it is genuinely needed.
- `NoMissingTypeAnnotation*`: add explicit top-level or let-bound annotations matching nearby style.
- `Simplify`: accept the simpler expression when it does not reduce readability.
- `NoDebug.*`: remove debug code instead of hiding it behind dead branches.
- Import or exposing rules: tighten imports and exposing lists rather than broadening them.
- Keep `review/` changes intentional and minimal.
- Preserve the ordering and grouping of rules when the config is already structured for performance or clarity.
- Prefer directory-scoped ignores over global weakening when tests or generated code need exceptions.
- If a new rule package is required, keep it intentional and validate the resulting config.
- Prefer the project's existing scripts over raw `elm-review` commands unless debugging a script problem.

## Final checks
- `elm-review` passes before the task is complete, or any remaining failure is stated clearly as a blocker.
- Elm code still compiles conceptually with the project's existing architecture and naming.
- Any config change in `review/src/ReviewConfig.elm` is deliberate, narrow, and explained.
- Relevant validation has been rerun using commands such as `npm run review`, `npm run review:fix`, `npm test`, or `npm run build` as appropriate.
