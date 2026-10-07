---
name: grill
description:
  Interview the user in relentless rounds through AskUserQuestion to sharpen a
  plan.
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

If the user passed arguments, treat them as the subject to grill.

## Deliver the round

Before every call, write a recap line in chat: what the last round settled, and
every fact a finished lookup returned. Lookup results reach the user only
through this line. Then call `AskUserQuestion` once:

- Up to 4 questions. If the frontier is larger, ask the 4 that block the most
  downstream questions and hold the rest for a later round.
- Prefix each question `Q<n>.` and keep counting across rounds, so the user can
  refer back to any question by number.
- Give every question exactly 3 drafted answers, open-ended ones included, then
  a fourth option labeled "Compare the above" with the description "Explain the
  trade-offs between these options in chat, then re-ask this question." The tool
  appends "Other" automatically for anything the user types; never draft one.
- Every question has exactly one recommended option among the 3 answers, listed
  first and labeled "(Recommended)". A recommendation that fits no option means
  the options are wrong.
- Use `preview` when the options are concrete artifacts to compare (code,
  layouts, configs, diagrams); plain preferences get label and description only.
  The "Compare the above" option never gets a `preview`.
- A question whose answer depends on another question still open in this round
  belongs to a later round.

Wait for the answers before the next round. If the user dismisses the form, stop
and let them redirect in chat; ask again only when they say so.

An "Other" answer that asks a question or shows confusion leaves that decision
open. Answer it in chat text, where the user can read it, before the next call,
and ask the clarified question again in the next round. A "Compare the above"
answer works the same way: compare that question's 3 options in chat, then ask
the same `Q<n>` again in the next round.

## Find facts yourself

A fact that lives in the environment is never the user's question. Dispatch an
agent for it and keep the rest of the round moving:

- Codebase facts: dispatch the `Explore` agent.
- External facts (docs, web): dispatch the `general-purpose` agent, told to
  return its findings inline.

A running lookup is an unsettled prerequisite, so the questions downstream of it
go in a later round. Ask the rest of the frontier now. A question whose options
would state a guess about a pending lookup is downstream of it. Every fact in an
option description is one you found, never one you suspect.

## Stop

The session is done when the frontier is empty: every branch of the design tree
visited, nothing left silently assumed. Then:

1. Print every settled decision as a compact numbered list in chat.
2. Call `AskUserQuestion` once: shared understanding reached, reached and write
   a spec, or keep grilling. Put the same numbered list in both "reached"
   options' `preview`, so the user confirms against decisions they can see. This
   call has no "Compare the above" option.
3. On "reached", act on the plan. On "write spec", follow
   `~/.claude/skills/to-spec/SKILL.md`. On "keep grilling", list every question
   and decision as `Q<n>. <question>: <the user's answer>`, ask in chat which
   decision to reopen, and resume the rounds from there.
