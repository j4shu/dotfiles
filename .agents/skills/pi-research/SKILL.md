---
name: pi-research
description: Research a question against primary sources with donsetch web tools, run on a background pi-researcher subagent, and save a cited brief where you choose.
disable-model-invocation: true
---

Run the research on a **background `pi-researcher` subagent** so you keep working while it reads. The agent loads donsetch's `web_search`, `web_fetch`, and `web_crawl` itself, so it needs no help from this session's extensions.

1. **Ask where the brief goes.** Look for the repo's existing findings convention first: a `research/`, `notes/`, or `docs/research/` directory, or a `docs/` tree that already holds notes. Put the detected path, a path the user types, and an answer-inline escape to them with `ask_user`, and wait. Never guess the destination.

2. **Frame the question.** One `pi-researcher` is the default. Fan out only when the question splits into genuinely distinct angles (official docs against ecosystem practice against a named benchmark). Give each child one angle; never send the same prompt with only a number changed.

3. **Dispatch.**

   Single brief:
   `subagent({ agent: "pi-researcher", async: true, task: "<question>\n\nWrite the brief to <path>." })`

   Fan-out: launch the angle children in one `runs.all` call, and build every `task` as an array of lines joined with `"\n"`. A backtick template literal breaks the script the moment a research prompt contains a code span:

   ```js
   const angles = [
     { key: "<angle>", task: ["<question>", "", "Write the brief to <dir>/<slug>-<angle>.md."].join("\n") },
   ];
   return await runs.all(angles.map((a) => ({ key: a.key, agent: "pi-researcher", task: a.task })));
   ```

   Then write `<dir>/<slug>.md` yourself as a heading, your 2 to 3 line synthesis, and a link to each angle brief. Never read the angle briefs into your own context. Report the synthesis path.

   Inline: the same task with `Return the brief inline; write no file.`

   The brief's shape and evidence rules live in the `pi-researcher` agent; do not restate them in the task. If the launch fails naming `web_search`, `web_fetch`, or `web_crawl` as unavailable, donsetch is not loaded: stop and say so.

4. **Report.** Hand the user the brief's path and the child's 2 to 3 line summary. Do not paste the whole brief.

Done when the brief exists at the chosen path, or the answer was returned inline, and every decision-relevant finding cites a source URL.
