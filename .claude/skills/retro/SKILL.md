---
name: retro
description:
  Review recent sessions in the current directory tree and suggest improvements
  to the agent's environment.
disable-model-invocation: true
---

Run a retrospective over recent sessions in the cwd and its subdirectories, and
suggest environment changes that would improve future runs. Do not apply any.

1. **Find sessions.** List the last `<n>` (default 5) matching transcripts,
   skipping the newest, which is the current session:

   ```sh
   ls -t $(grep -l "\"cwd\":\"$(pwd)" ~/.claude/projects/*/*.jsonl) | sed -n "2,$((n+1))p"
   ```

2. **Read.** Dispatch a `general-purpose` agent per transcript, all in parallel,
   told to return its findings inline: evidence of friction in each category
   below, with the session's reference, `"<name>" (YYYY-MM-DD, <id>)`. The name
   is the last `custom-title` line's `customTitle`, else the last `ai-title`
   line's `aiTitle`; the date is the first `timestamp`; `<id>` is the session
   id's first 8 characters. With no name, the reference is `<id> (YYYY-MM-DD)`.
   - **Steering files**: `CLAUDE.md` instructions that are bloated or change
     nothing.
   - **Navigation**: the agent took long to find a file or fact; a pointer would
     help.
   - **Automated checks**: a mistake a lint, type check, test, or hook would
     have caught.
   - **Tool economy**: expensive or repeated tool calls that could be
     streamlined.
   - **Information access**: a crucial fact the agent could not reach.
   - **Skills**: skill wording that caused a misstep.
3. **Report.** Merge the findings and list them in chat under a `## <category>`
   heading per category, in the order above, skipping empty ones. Within each,
   sort by priority, highest first, one line each:
   `- <fix>. (sessions <references>)`.

If the user passed arguments, treat them as `<n>`, the number of sessions.
