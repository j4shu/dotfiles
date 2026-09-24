#!/usr/bin/env python3
"""Claude Code status line.

Reads the session JSON piped to stdin by Claude Code and prints one line:

    <context> · <cwd> · <branch>      <model> · <reset time> (<5h used>%)

The right side is padded to the terminal edge ($COLUMNS); if it doesn't fit it
follows the left side after the separator.
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
        cmd = ["git", "branch", "--show-current"]
        return (
            subprocess.run(
                cmd, cwd=cwd, capture_output=True, text=True, timeout=1
            ).stdout.strip()
            or None
        )
    except Exception:
        return None


def main():
    data = json.load(sys.stdin)
    model = data.get("model") or {}
    cwd = data["workspace"]["current_dir"]

    tokens = (data.get("context_window") or {}).get("total_input_tokens")
    context = f"{(tokens or 0) / 1000:.0f}k"

    left = [context, shorten_cwd(cwd)]
    branch = git_branch(cwd)
    if branch:
        left.append(branch)

    right = []
    if model.get("display_name"):
        effort = (data.get("effort") or {}).get("level")
        right.append(
            f"{model['display_name']} ({effort})" if effort else model["display_name"]
        )

    # resets_at is a Unix epoch in seconds; used_percentage is already 0-100.
    five_hour = ((data.get("rate_limits") or {}).get("five_hour")) or {}
    if five_hour.get("resets_at"):
        reset = datetime.fromtimestamp(five_hour["resets_at"]).strftime("%H:%M")
        right.append(f"{reset} ({five_hour.get('used_percentage', 0):.0f}%)")

    # Measure before coloring, since escape codes count in len() but not on screen.
    left_len = len(SEP.join(left))
    if branch:
        left[-1] = f"\033[32m{left[-1]}\033[0m"  # green
    left_s, right_s = SEP.join(left), SEP.join(right)
    # Claude Code renders 4 columns narrower than $COLUMNS.
    width = int(os.environ.get("COLUMNS", 0)) - 4
    gap = width - left_len - len(right_s)
    pad = " " * gap if gap >= len(SEP) else SEP
    sys.stdout.write(left_s + (pad + right_s if right_s else ""))


if __name__ == "__main__":
    main()
