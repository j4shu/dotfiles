---
name: implement-spec
description:
  Implement a spec written by to-spec in the working tree, one task at a time.
disable-model-invocation: true
---

Implement the spec in the working tree. Do not create branches or commits.

1. **Read the spec.** If the user gave no path, ask for one in chat.
2. **Derive the task graph.** Split the spec's User Stories and Implementation
   Decisions into tasks, each with the tasks that block it. The **frontier** is
   every task whose blockers are done.
3. **Confirm.** Call `AskUserQuestion` once to confirm the graph, with the tasks
   and blocking edges in `preview`, then adjust it to the answer.
4. **Implement.** Take one frontier task at a time and dispatch a
   `general-purpose` agent for it. Pass pointers (spec path, task) rather than
   copies. The agent writes a failing test at the seams in the spec's Testing
   Decisions, then makes it pass. If the agent cannot get its tests passing,
   stop and go to step 5.
5. **Report.** One line per task (done, failed, or not started), the files
   changed, and the final test run's result.

If the user passed arguments, treat them as the path to the spec.
