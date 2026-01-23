#!/usr/bin/env bash
set -euo pipefail

# Read stdin, replace newlines with spaces (and collapse runs of whitespace),
# then speak via gtts-cli and play via ffplay.
#
# Usage:
#   echo -e "line1\nline2" | gtts
#   cat file.txt | gtts

text="$(
  cat \
  | tr '\r\n' '  ' \
  | sed 's/[[:space:]]\+/ /g; s/^ //; s/ $//'
)"

# If there's nothing to say, exit cleanly
[[ -n "${text}" ]] || exit 0

printf '%s' "$text" \
  | gtts-cli -f /dev/stdin \
  | ffplay -nodisp -autoexit -loglevel error -af "atempo=1.5" - 1>/dev/null
