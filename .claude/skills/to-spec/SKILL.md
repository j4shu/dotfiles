---
name: to-spec
description:
  Turn the current conversation into a spec saved as a Markdown file. No
  interview, just synthesis of what has already been discussed.
disable-model-invocation: true
---

Synthesize the conversation into a spec. Do not interview the user; the one
exception is the seam and location check below.

1. **Fill gaps.** For codebase facts the conversation has not covered, dispatch
   the `Explore` agent. Use the project's domain vocabulary throughout.
2. **Pick test seams.** Prefer existing seams to new ones, and the highest seam
   possible. The fewer seams the better; the ideal is one.
3. **Save.** Pick a short kebab-case `<slug>` from the feature. Before writing,
   call `AskUserQuestion` once to confirm the seams and ask where to save, with
   these options:
   - `<cwd>/spec-<slug>.md`, listed first and labeled "(Recommended)".
   - The automatic "Other" carries a custom path.

   Write the spec there with the template below and report the path.

If the user passed arguments, treat them as the feature to focus the spec on.

## Template

- **Problem**: the problem, from the user's perspective.
- **Solution**: the solution, from the user's perspective.
- **User Stories**: a numbered list covering every aspect of the feature, each
  as "As a <actor>, I want <feature>, so that <benefit>".
- **Implementation Decisions**: modules built or modified and their interfaces,
  architectural decisions, schema changes, API contracts, specific interactions,
  and technical clarifications from the user. No file paths or code, since they
  go stale. Exception: a prototype snippet that pins a decision more precisely
  than prose (schema, type shape, state machine), trimmed to the decision-rich
  part and marked as from a prototype.
- **Testing Decisions**: the agreed seams, which modules are tested, prior art
  in the codebase. Good tests check external behavior, not implementation
  details.
- **Out of Scope**: what this spec deliberately leaves out.
