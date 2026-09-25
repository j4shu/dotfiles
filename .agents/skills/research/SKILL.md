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
2. Write the findings to `<cwd>/research/<slug>.md`, citing each claim's source.
   `<slug>` is a short kebab-case name from the topic; create the folder if
   missing.
3. Report the path.
