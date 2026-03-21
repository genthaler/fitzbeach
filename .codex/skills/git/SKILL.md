# Git Skill

## When to use
- Suggest a commit message after file changes.
- Inspect git status or diff to understand what changed.
- Check whether the working tree contains unrelated changes before summarising work.

## When not to use
- Staging, committing, or rewriting history unless the user explicitly asks for git actions.
- Non-git summary tasks where repository state is irrelevant.

## Workflow
1. Inspect the current git state.
   - Read `git status --short` first.
   - Check `git diff --stat` or equivalent to understand the scope quickly.
   - Use the diff against `HEAD` when forming a commit summary.
2. Call out unrelated changes before suggesting a commit message.
3. Distinguish message suggestion from git actions.
   - Suggest the commit message without assuming files should be staged or committed.
4. Prefer short imperative commit messages.
5. Prefix commit messages with a change type such as `Feature:`, `Refactor:`, `Style:`, `Documentation:`, `Fix:`, or `Chore:`.
   - If you would normally default to Conventional Commits like `feat:`, `fix:`, or `refactor:`, override that habit here and use the initial-cap prefixes above instead.

## Expectations
- Base the suggestion on the full current diff against `HEAD`, not only the most recent edit.
- Do not hide unrelated changes in the working tree.
- Mention when unrelated changes should not be included in the suggested commit scope.
- Keep the suggested message compact and descriptive.
