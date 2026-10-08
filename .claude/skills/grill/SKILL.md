---
name: grill
description: Interview the user in rounds until a plan is fully decided.
disable-model-invocation: true
---

Interview the user relentlessly until you reach a shared understanding. Map the
subject as a **design tree**, where every decision branches into the decisions
that hang off it, and work it in **rounds**: one `AskUserQuestion` call each,
with the questions in the form, not your reply text. The **frontier** is every
decision whose prerequisites are settled; recompute it after each round.

If the user passed arguments, treat them as the subject to grill.

## Deliver the round

Before every call, write a recap line in chat: what the last round settled, and
every fact a finished lookup returned. Then call `AskUserQuestion` once:

- Up to 4 questions. If the frontier is larger, ask the 4 that block the most
  downstream questions.
- Prefix each question `Q<n>.`, counting across rounds.
- Give every question 2 to 4 drafted answers, one per real alternative,
  open-ended ones included. Never draft an "Other"; the tool adds it.
- Exactly one answer is recommended, listed first and labeled "(Recommended)".
  If your recommendation fits no option, redraft the options.
- Use `preview` only when the options are concrete artifacts to compare (code,
  layouts, configs, diagrams).
- A question that depends on another one still open goes in a later round.

Wait for the answers. If the user dismisses the form, stop and let them redirect
in chat; ask again only when they say so.

An "Other" answer that asks a question or shows confusion leaves the decision
open: answer it in chat, then re-ask the clarified question next round.

## Find facts yourself

Never ask the user a fact that lives in the environment. Dispatch an agent for
it and keep the round moving:

- Codebase facts: dispatch the `Explore` agent.
- External facts (docs, web): dispatch the `general-purpose` agent, told to
  return its findings inline.

A running lookup is an unsettled prerequisite: questions downstream of it,
including any whose options would guess at its result, wait for a later round.
Every fact in an option description is one you found, never one you suspect.

## Stop

The session is done when the frontier is empty: every branch visited, nothing
silently assumed.

1. **Recap.** Print every settled decision as a compact numbered list in chat.
2. **Confirm.** Call `AskUserQuestion` once: shared understanding reached,
   reached and write a spec, or keep grilling.
3. **Act.** On "reached", act on the plan. On "write spec", follow
   `~/.claude/skills/to-spec/SKILL.md`. On "keep grilling", list every question
   as `Q<n>. <question>: <the user's answer>`, ask in chat which decision to
   reopen, and resume the rounds from there.
