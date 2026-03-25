# Skill Authoring

Create or revise repo-local Codex skills using a consistent structure so they are easy to apply, maintain, and discover.

## When to use

- When creating a new repo-local skill under `./.agents/skills/`
- When revising the structure or wording of an existing repo-local skill
- When normalising multiple local skills to a shared format

## When not to use

- When editing `AGENTS.md` without changing any local skills
- When working with global skills outside this repository
- When the task is to execute a skill rather than define or revise one

## Workflow

1. Read the current `AGENTS.md` rules that apply to local skills and list the repo-specific requirements the skill needs to reinforce.
2. Define the skill scope narrowly. The title and `when to use` section should describe a specific class of tasks, not a broad domain.
3. Write the `SKILL.md` using this section order:
   - title
   - when to use
   - when not to use
   - workflow
   - fixing guidance
   - final checks
4. Do not add YAML frontmatter to `SKILL.md`. Keep machine-readable skill metadata only in `agents/openai.yaml`.
5. Keep the content concrete. Prefer task-shaped instructions, repo paths, commands, and completion criteria over abstract advice.
6. Create or update `agents/openai.yaml` for the skill with a short name and one-sentence description.
7. If the new skill changes how future prompts should be written or how skills should be formatted, update `AGENTS.md` in the same change.

## Fixing guidance

- If a skill is too broad, split it by workflow rather than by technology label alone.
- If a section would be empty, keep it and write a short explicit statement rather than deleting the section.
- If a skill duplicates another local skill, either narrow the new skill or add cross-references so trigger choice stays clear.
- If instructions are repo-specific but not stable, keep them in `AGENTS.md` and reference them from the skill instead of copying them repeatedly.

## Final checks

- Confirm the `SKILL.md` uses the canonical section order.
- Confirm the `SKILL.md` does not include YAML frontmatter.
- Confirm `agents/openai.yaml` exists and matches the skill name and purpose.
- Confirm the skill does not restate large parts of `AGENTS.md` unless the repetition is necessary for correct use.
- If the skill was added or significantly changed, check whether `AGENTS.md` should mention it in the local skills list or project rules.
