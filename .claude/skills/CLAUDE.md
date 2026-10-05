# Skills

Follow the standards below when creating or editing a skill.

## Index

| Skill            | Does                                                    |
| ---------------- | ------------------------------------------------------- |
| `grill`          | Interviews you in rounds until a plan is fully decided. |
| `to-spec`        | Turns the conversation into a spec file.                |
| `implement-spec` | Implements a spec in the working tree, task by task.    |
| `handoff`        | Compacts the conversation into a doc for a fresh agent. |
| `research`       | Researches a question against primary sources.          |
| `retro`          | Reviews recent cwd sessions and suggests changes.       |

Typical chain: `grill` -> `to-spec` -> `implement-spec`. `grill` can hand off to
`to-spec` directly; the others run independently.

## Standards

- **Terse**: say each rule once, in the fewest words that keep it unambiguous.
- **Frontmatter**: the description starts with an imperative verb. User-only
  skills set `disable-model-invocation: true` and have no "Use when..." clause;
  only model-invocable skills get one.
- **Structure**: a linear skill has one intro sentence, then numbered steps that
  each open with a bold label (`1. **Save.** ...`). A looping skill, like
  `grill`, uses `##` sections instead.
- **Arguments**: every skill ends its steps with "If the user passed arguments,
  treat them as <X>."
- **Subagents**: write "Dispatch the `<type>` agent". Pass pointers (paths, ids)
  rather than copies, and tell agents that report back to return their findings
  inline.
- **Saving files**: output goes to `<cwd>/<kind>-<slug>.md`, asked for with the
  shared save block below.

## Skeleton

```markdown
---
name: <name>
description: <Verb> <what it does>.
disable-model-invocation: true
---

<One sentence stating the goal.>

1. **<Label>.** <step>
2. **Save.** Pick a short kebab-case `<slug>` from the <topic>. Before writing,
   call `AskUserQuestion` once to ask where to save, with these options:
   - `<cwd>/<kind>-<slug>.md`, listed first and labeled "(Recommended)".
   - The automatic "Other" carries a custom path.

   Write the file there and report the path.

If the user passed arguments, treat them as <X>.
```
