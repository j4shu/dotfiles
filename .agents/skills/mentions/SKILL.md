---
name: mentions
description:
  Fix or answer the open review comments collected in a mention.nvim buffer.
disable-model-invocation: true
---

The user reviews code in Neovim and collects comments with mention.nvim. Each
comment is a **block** in the project's mention file. Handle every open block.

## The mention file

mention.nvim keeps one file per project, named after Neovim's cwd with every
`/`, `\` and `:` replaced by `%`:

```sh
dir="${XDG_STATE_HOME:-$HOME/.local/state}/nvim/mention.nvim"
file="$dir/$(pwd | tr '/:' '%%')"
```

Use the file for the cwd when it exists. Only when it is missing, run
`git rev-parse --show-toplevel` and try the file for that directory; with that
missing too, report both paths tried and stop.

## Blocks

A block is a run of mention lines plus the text below the run. A mention always
belongs to a comment, so only text ends a block: mentions with nothing but blank
lines between them share the comment below.

```text
[Resolved]
@~/git/app/src/api.ts#L10-24
this retry loop never backs off

@~/git/app/src/api.ts#L40
@~/git/app/src/client.ts
these two disagree on the timeout
```

- `@path#L<from>-<to>` or `@path#L<n>` names a line range; `@path` alone names
  the whole file.
- A block whose first mention sits directly under a `[Resolved]` line is closed.
  Every other block is **open**.
- An open block is a **question** when its text asks something rather than
  requesting a change. Answer it in the report; the code stays as it is.
- An open block is **unclear** when its text is missing or leaves the intended
  change in doubt.

## Steps

1. Read the mention file. If 0 open blocks, reply "No open mentions." and stop.
2. Read every range mentioned by an open block before editing anything. Line
   numbers are exact and refer to the files as they stand now, so resolve each
   block against this first reading as your edits shift lines.
3. Fix each clear open block in the code and work out the answer to each
   question. Leave unclear blocks alone.
4. Run the project's own checks for the touched area.
5. With the Edit tool, insert a `[Resolved]` line directly above the first
   mention of each block you fixed or answered. Change nothing else in the file.
6. Report as a bulleted list, one bullet per open block and nothing about closed
   ones: what changed, the answer to its question, or why it was skipped as
   unclear. Close with a bullet for the check results, with failures called out.
