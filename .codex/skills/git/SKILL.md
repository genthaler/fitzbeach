---
name: "git"
description: "Use when working with git status and diffs, especially when suggesting commit messages after approved file changes. Base suggestions on the current diff against `HEAD`, note unrelated working tree changes, and prefer short imperative commit messages with a change-type prefix."
---

# Git Skill

## When to use
- Suggest a commit message after file changes.
- Inspect git status or diff to understand what changed.
- Check whether the working tree contains unrelated changes before summarising work.

## Workflow
1. Inspect the current git state.
   - Read `git status --short` first.
   - Use the diff against `HEAD` when forming a commit summary.
2. Call out unrelated changes before suggesting a commit message.
3. Prefer short imperative commit messages.
4. Prefix commit messages with a change type such as `Feature:`, `Refactor:`, `Style:`, `Documentation:`, `Fix:`, or `Chore:`.

## Expectations
- Base the suggestion on the full current diff against `HEAD`, not only the most recent edit.
- Do not hide unrelated changes in the working tree.
- Keep the suggested message compact and descriptive.
