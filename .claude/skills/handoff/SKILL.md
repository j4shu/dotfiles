---
name: handoff
description:
  Compact the current conversation into a handoff document for another agent to
  pick up.
disable-model-invocation: true
---

Write a handoff document summarizing the current conversation so a fresh agent
can continue the work.

1. **Write.** Do not duplicate content already captured in other artifacts
   (specs, plans, ADRs, issues, commits, diffs). Reference them by path or URL
   instead.
2. **Save.** Pick a short kebab-case `<slug>` from the work. Before writing,
   call `AskUserQuestion` once to ask where to save, with these options:
   - `<cwd>/handoff-<slug>.md`, listed first and labeled "(Recommended)".
   - The automatic "Other" carries a custom path.

   Write the file there and report the path.

If the user passed arguments, treat them as what the next session will focus on
and tailor the doc accordingly.
