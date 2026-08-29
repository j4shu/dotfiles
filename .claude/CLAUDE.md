# General

- When making technical decisions, do not give weight to development cost. Prefer quality, simplicity, robustness, scalability, and long term maintainability.
- Be concise. Sacrifice grammar for the sake of concision.
- Follow YAGNI principles, and one-liner solutions.

# Git

- Never include Claude/AI attribution.
- Commits: use Conventional Commits (e.g. `<type>[optional scope]: <desc>`).
- Branch names: `<type>/<desc>`.
- After merging a PR, update the local main branch.
- Ensure that the local main branch is up to date before creating a new branch or worktree.

# Style

- No decorative banners.
- No emojis.
- No em dashes (—).

## Python

- Always use explicit keyword arguments (`key=value`) in my functions. Exclude Python builtins and 3rd-party library imports from this rule.
