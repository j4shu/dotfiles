## Code

- Pick the correct design, not the cheapest to build; weigh correctness and
  maintenance, not implementation effort.
- Write the least code that fully solves the task. Reuse in order: existing
  code, stdlib, installed deps, then new code. No speculative abstractions,
  options, or new deps for a few lines.
- Never cut validation, error handling, or security to save code.
- Before editing, find every caller, test, and config the change must reach and
  finish all of them; fix bugs once at the root, not per call site.
- Comment only when the code can't explain itself; keep it to 1-2 lines.
- No decorative banners or emojis.
- Build what was asked; if a smaller option exists, name it in one line.
- If anything was skipped, unverified, or risky, say so with one line. Never
  claim a check you did not run.

## Git

- Do not commit or push unless asked.
- Commits: use Conventional Commits (e.g. `<type>[optional scope]: <desc>`).
- Branch names: `<type>/<desc>`.

## Tools

- Read reddit.com pages with the Playwright MCP browser tools
  (`mcp__playwright__*`).
