#!/usr/bin/env python3
"""Claude Code status line.

Reads the session JSON piped to stdin by Claude Code and prints one line:

    <cwd> · <branch> · <model> · <context tokens> · <reset time> (<5h used>%)

The quota segment is omitted until the CLI has seen a rate-limit header.
"""

import json
import os
import subprocess
import sys
from datetime import datetime

# On Windows the console defaults to cp1252, which can't encode the · separator.
# Force UTF-8 so the line renders instead of crashing with UnicodeEncodeError.
try:
    sys.stdout.reconfigure(encoding="utf-8")
except Exception:
    pass

SEP = " · "  # separator between segments


def shorten_cwd(path):
    home = os.path.expanduser("~")
    if path == home or path.startswith(home + os.sep):
        return "~" + path[len(home) :]
    return path


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


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    model = data.get("model") or {}
    workspace = data.get("workspace") or {}
    cwd = workspace.get("current_dir") or data.get("cwd") or os.getcwd()

    seg = [shorten_cwd(cwd)]
    branch = git_branch(cwd)
    if branch:
        seg.append(f"\033[32m {branch}\033[0m")
    if model.get("display_name"):
        effort = (data.get("effort") or {}).get("level")
        seg.append(
            f"{model['display_name']} ({effort})" if effort else model["display_name"]
        )

    tokens = (data.get("context_window") or {}).get("total_input_tokens", 0)
    seg.append(f"{tokens / 1000:.0f}k")

    # resets_at is a Unix epoch in seconds; used_percentage is already 0-100.
    five_hour = ((data.get("rate_limits") or {}).get("five_hour")) or {}
    if five_hour.get("resets_at"):
        reset = datetime.fromtimestamp(five_hour["resets_at"]).strftime("%H:%M")
        seg.append(f"{reset} ({five_hour.get('used_percentage', 0):.0f}%)")

    sys.stdout.write(SEP.join(seg))


if __name__ == "__main__":
    main()
