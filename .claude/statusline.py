#!/usr/bin/env python3
"""Claude Code status line.

Reads the session JSON piped to stdin by Claude Code, pulls the live context-token
count from the session transcript, and prints one line:

    <cwd> · <model> · <tokens>/<limit> (<pct>) · $<cost> · <duration>

Plain text, no colors.
"""

import json
import os
import subprocess
import sys

# On Windows the console defaults to cp1252, which can't encode the · separator.
# Force UTF-8 so the line renders instead of crashing with UnicodeEncodeError.
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

# ---- config -----------------------------------------------------------------
CONTEXT_LIMIT = 200_000  # token count is shown as a % of this (auto-compact window)
CWD_SEGMENTS = 2  # trailing path segments to show for cwd
SEP = " · "  # separator between segments


def human_tokens(n):
    if n >= 1_000_000:
        return f"{n / 1_000_000:.1f}M"
    if n >= 1_000:
        return f"{n / 1_000:.1f}k"
    return str(n)


def human_duration(ms):
    m = int(ms // 60000)
    if m < 60:
        return f"{m}m"
    h, m = divmod(m, 60)
    return f"{h}h{m:02d}m"


def shorten_cwd(path):
    home = os.path.expanduser("~")
    if path == home:
        return "~"
    if path.startswith(home + os.sep):
        parts = path[len(home) + 1 :].split(os.sep)
        tail = os.sep.join(parts[-CWD_SEGMENTS:])
        return "~/" + tail if len(parts) <= CWD_SEGMENTS else "~/…/" + tail
    parts = [p for p in path.split(os.sep) if p]
    if len(parts) <= CWD_SEGMENTS:
        return path
    return "…/" + os.sep.join(parts[-CWD_SEGMENTS:])


def git_branch(cwd):
    """Current branch name, or None if cwd isn't a git repo / is detached."""
    try:
        out = subprocess.run(
            ["git", "symbolic-ref", "--short", "HEAD"],
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=1,
        )
    except Exception:
        return None
    branch = out.stdout.strip()
    return branch if out.returncode == 0 and branch else None


def context_tokens(path):
    """Sum of the last assistant message's usage; 0 if unreadable."""
    total = 0
    try:
        with open(path) as fh:
            for line in fh:
                line = line.strip()
                if not line:
                    continue
                try:
                    usage = json.loads(line).get("message", {}).get("usage")
                except Exception:
                    continue
                if isinstance(usage, dict):
                    total = (
                        usage.get("input_tokens", 0)
                        + usage.get("cache_creation_input_tokens", 0)
                        + usage.get("cache_read_input_tokens", 0)
                    )
    except Exception:
        pass
    return total


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    model = data.get("model") or {}
    workspace = data.get("workspace") or {}
    cost = data.get("cost") or {}
    cwd = workspace.get("current_dir") or data.get("cwd") or os.getcwd()
    tokens = (
        context_tokens(data["transcript_path"]) if data.get("transcript_path") else 0
    )

    seg = [shorten_cwd(cwd)]
    branch = git_branch(cwd)
    if branch:
        seg.append(f" {branch}")
    if model.get("display_name"):
        seg.append(model["display_name"])

    pct = (tokens / CONTEXT_LIMIT * 100) if CONTEXT_LIMIT else 0
    seg.append(f"{human_tokens(tokens)}/{human_tokens(CONTEXT_LIMIT)} ({pct:.0f}%)")

    if cost.get("total_cost_usd") is not None:
        seg.append(f"${cost['total_cost_usd']:.2f}")
    if cost.get("total_duration_ms"):
        seg.append(human_duration(cost["total_duration_ms"]))

    sys.stdout.write(SEP.join(seg))


if __name__ == "__main__":
    main()
