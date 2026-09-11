---
name: pi-grilling
description: A relentless round-based interview to sharpen a plan, delivered through the ask_user form.
disable-model-invocation: true
---

Interview the user relentlessly until you reach a shared understanding. Map the subject as a **design tree**: every decision branches into the decisions that hang off it. Work the tree in **rounds**.

A round is one `ask_user` call. The questions live in the form, not in your reply text. The **frontier** is every decision whose prerequisites are settled: the questions you can ask now without guessing at answers you have not heard. Recompute the frontier after each round, because the user's answers push it outward and unblock questions that depended on them.

## Deliver the round

Call `ask_user` once with the whole frontier:

- `numbered: true`, so the form mirrors the tree's question order.
- One entry per question: a unique `id`, a `prompt` carrying the full body (explain the options in prose when they need it), and `type: "choice"` with an `options` list, or `type: "text"` for a free-form ask.
- `recommendation` on every question: your recommended answer. Make it match one option's `value` or `label` so that option is highlighted; otherwise it shows as a hint under the question. A recommendation you cannot map to an option means the options are wrong.
- Leave `allowOther` on (the default) so the user can type an answer you did not list.
- A question whose answer depends on another question still open in this round belongs to a later round, not this one.
- A round caps at 10 questions. If the frontier is larger, ask the 10 that block the most downstream questions and hold the rest.

Wait for the answers before asking the next round. If the user cancels the form, stop and let them redirect; do not re-ask.

## Find facts yourself

A fact that lives in the environment is never the user's question. Dispatch a subagent for it and keep the rest of the round moving.

- Codebase facts: `subagent({ agent: "scout", task: "<what to find>" })`.
- External facts: `subagent({ agent: "pi-researcher", task: "<question>\n\nReturn the brief inline; write no file." })`.

A running lookup is an unsettled prerequisite, so the questions downstream of it go in a later round. Never stall the whole round waiting on it.

## Stop

The session is done when the frontier is empty: every branch of the design tree visited, nothing left silently assumed. Do not act on it until the user confirms you have reached a shared understanding.
