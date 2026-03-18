---
name: "readme-sync"
description: "Use when code or configuration changes may affect user-visible behaviour, setup, controls, commands, architecture notes, or project structure. Check whether `README.md` should be updated and keep documentation aligned with the current state of the project."
---

# README Sync Skill

## When to use
- A change affects setup, commands, controls, visible behaviour, architecture notes, or file structure.
- A repo has a `README.md` that should stay aligned with the actual app.
- You need a final documentation pass after code changes.

## Workflow
1. Read the relevant README sections after understanding the code change.
2. Compare current behaviour and setup against what the README claims.
3. Update only the sections affected by the change.
4. Do not describe planned features as if they already exist.

## Expectations
- Keep instructions accurate and minimal.
- Match the terminology used in the codebase.
- Preserve working setup commands unless they truly changed.
- Mention when no README update is needed after checking.
