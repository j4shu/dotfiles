---
name: research
description:
  Investigate a question against high-trust primary sources and capture the
  findings as a Markdown file. Use when the user wants a topic researched, docs
  or API facts gathered, or reading legwork delegated to a background agent.
---

Spin up a **background agent** to do the research, so you keep working while it
reads. Its job:

1. Investigate the question against **primary sources** (official docs, source
   code, specs, first-party APIs), not a secondary write-up of them. Follow
   every claim back to the source that owns it.
2. Return the findings inline as a single Markdown document, citing each claim's
   source. Do not write any file.

Right after spawning it, pick a short kebab-case `<slug>` from the topic and
call `AskUserQuestion` once to ask where to save it, showing full paths:

- `<cwd>/research/<slug>.md` (Recommended)
- `~/Desktop/research/<slug>.md`

The automatic "Other" carries a custom path and/or filename. When the agent
finishes, create the folder if missing, write the file there, and report the
path.
