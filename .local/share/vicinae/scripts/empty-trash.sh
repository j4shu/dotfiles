#!/usr/bin/env bash

# @raycast.schemaVersion 1
# @raycast.title Empty Trash
# @raycast.mode silent
# @raycast.icon 🗑️
# @raycast.packageName

set -euo pipefail

if err=$(osascript -e 'tell application "Finder" to empty trash' 2>&1); then
  echo "Emptied Trash"
elif [[ "$err" == *"(-128)"* ]]; then
  echo "Trash is already empty"
else
  echo "$err"
  exit 1
fi
