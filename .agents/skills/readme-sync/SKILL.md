# README Sync Skill

## When to use
- A change affects setup, commands, controls, visible behaviour, architecture notes, or file structure.
- A repo has a `README.md` that should stay aligned with the actual app.
- You need a final documentation pass after code changes.

## When not to use
- Internal refactors with no user-visible or setup impact.
- Repos where no README maintenance expectation exists.

## Workflow
1. Read the relevant README sections after understanding the code change.
2. Compare current behaviour and setup against what the README claims.
3. Update only the sections affected by the change.
4. Update examples, commands, and file paths together so documentation does not drift partially.
5. Do not describe planned features as if they already exist.

## Fixing guidance
- Keep instructions accurate and minimal.
- Match the terminology used in the codebase.
- Preserve working setup commands unless they truly changed.
- Avoid documenting internal implementation details unless the README already does.
- State explicitly when no README change is needed after checking.

## Final checks
- `README.md` matches the current app behaviour, commands, and structure affected by the change.
- Examples, commands, and paths have been updated together where needed.
- If no README change was required, that decision is stated explicitly.
