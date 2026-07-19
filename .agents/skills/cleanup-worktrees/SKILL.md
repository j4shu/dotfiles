---
name: cleanup-worktrees
description: End-of-day cleanup of worktrees and local branches whose work has landed on main.
disable-model-invocation: true
---

# Cleanup worktrees

Remove worktrees and delete local branches whose work has landed on main. Squash merges make `git branch -d` and `--merged` unreliable: a landed branch still shows unique commits. Merged PRs are the source of truth for what landed.

## Steps

1. **Sync.** In the primary checkout, on main: `git pull`, then `git fetch --prune`. Done when main is up to date with origin and stale remote-tracking refs are gone.
2. **Classify.** Gather `git worktree list`, `git branch -vv`, and `gh pr list --state all --limit 200 --json number,state,headRefName`. Done when every local branch except main is classified as exactly one of:
   - **landed**: head branch of a MERGED PR, or `git rev-list --count main..<branch>` is 0
   - **backed up**: not landed, but in sync with a live origin branch (no `[ahead]`, no `: gone`)
   - **at risk**: anything else; its commits exist nowhere but this machine
3. **Remove worktrees.** For each worktree except the primary checkout: if `git status --porcelain` in it is non-empty or its branch is at risk, keep it and record why; otherwise `git worktree remove` it. Finish with `git worktree prune`. Done when `git worktree list` shows only the primary checkout plus recorded keeps.
4. **Delete branches.** `git branch -D` every landed and backed-up branch. Keep at-risk branches untouched. Never delete anything on origin; if landed branches linger on origin, list the `git push origin --delete ...` command for the user instead. Done when `git branch` shows only main plus at-risk branches.
5. **Report.** One line per branch and worktree from step 2: deleted, or kept with its reason. Done when every item is accounted for.
