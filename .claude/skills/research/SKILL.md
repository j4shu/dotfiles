---
name: research
description:
  Investigate a question against high-trust primary sources and capture the
  findings as a Markdown file. Use when the user wants a topic researched, docs
  or API facts gathered, or reading legwork delegated to a background agent.
---

Research the question in the background and save the findings as a Markdown
file, so you keep working while the agent reads.

1. **Research.** Dispatch a background `general-purpose` agent, told to:
   - Investigate the question against **primary sources** (official docs, source
     code, specs, first-party APIs), not a secondary write-up of them. Follow
     every claim back to the source that owns it.
   - Return its findings inline as a single Markdown document, citing each
     claim's source. Do not write any file.
2. **Save.** Pick a short kebab-case `<slug>` from the topic. Right after
   dispatching the agent, call `AskUserQuestion` once to ask where to save, with
   these options:
   - `<cwd>/research-<slug>.md`, listed first and labeled "(Recommended)".
   - `<cwd>/research/<slug>.md`.
   - The automatic "Other" carries a custom path.

   When the agent finishes, write the file there and report the path.

If the user passed arguments, treat them as the question to research.
