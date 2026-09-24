---
name: grill
description:
  A relentless round-based interview to sharpen a plan, delivered through
  AskUserQuestion.
disable-model-invocation: true
---

Interview the user relentlessly until you reach a shared understanding. Map the
subject as a **design tree**: every decision branches into the decisions that
hang off it. Work the tree in **rounds**.

A round is one `AskUserQuestion` call. The questions live in the form, not in
your reply text. The **frontier** is every decision whose prerequisites are
settled: the questions you can ask now without guessing at answers you have not
heard. Recompute the frontier after each round, because the user's answers push
it outward and unblock questions that depended on them.

## Deliver the round

Before every call, write a recap line in chat: what the last round settled, and
every fact a finished lookup returned. Lookup results reach the user only
through this line. Then call `AskUserQuestion` once:

- Up to 4 questions. If the frontier is larger, ask the 4 that block the most
  downstream questions and hold the rest for a later round.
- Prefix each question `Q<n>.` and keep counting across rounds, so the user can
  refer back to any question by number.
- Give every question 2-4 options, open-ended ones included: draft plausible
  answers and let the automatic "Other" carry anything the user types.
- Every question has exactly one recommended option, listed first and labelled
  with a "(Recommended)" suffix. A recommendation that fits no option means the
  options are wrong.
- Use `preview` when the options are concrete artifacts to compare (code,
  layouts, configs, diagrams); plain preferences get label and description only.
- A question whose answer depends on another question still open in this round
  belongs to a later round.

Wait for the answers before the next round. If the user dismisses the form, stop
and let them redirect in chat; ask again only when they say so.

## Find facts yourself

A fact that lives in the environment is never the user's question. Dispatch a
subagent for it and keep the rest of the round moving:

- Codebase facts: the `Explore` agent.
- External facts (docs, web): the `general-purpose` agent, told to return its
  findings inline.

A running lookup is an unsettled prerequisite, so the questions downstream of it
go in a later round. Ask the rest of the frontier now. A question whose options
would state a guess about a pending lookup is downstream of it. Every fact in an
option description is one you found, never one you suspect.

## Stop

The session is done when the frontier is empty: every branch of the design tree
visited, nothing left silently assumed. Then:

1. Print every settled decision as a compact numbered list in chat.
2. Call `AskUserQuestion` once: shared understanding reached, or keep grilling.
   Put the same numbered list in the "reached" option's `preview`, so the user
   confirms against decisions they can see.
3. On "reached", act on the plan. On "keep grilling", ask in chat which decision
   to reopen, and resume the rounds from there.
