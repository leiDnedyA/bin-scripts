#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
replace-recursively.sh — replace a substring across files safely (handles spaces)

USAGE:
  replace-recursively.sh <search> <replace> [path]

ARGS:
  <search>    The substring (or regex) to look for.
  <replace>   The replacement text.
  [path]      Directory to search (default: current directory).

NOTES:
  - Uses: rg -l0 ... | xargs -0 sd ...
  - Filenames with spaces/newlines are handled safely via NUL delimiters.
  - <search> is treated as a regex by sd. Escape special chars if you want literal matching.
  - Requires: ripgrep (rg), sd, xargs.

EXAMPLES:
  replace-recursively.sh 'urlUtilities\.js' 'urlUtilities' src
  replace-recursively.sh 'foo' 'bar' .
EOF
}

# Help
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

# Args
if [[ $# -lt 2 || $# -gt 3 ]]; then
  echo "Error: expected 2 or 3 arguments." >&2
  echo
  usage
  exit 2
fi

SEARCH=$1
REPLACE=$2
ROOT=${3:-.}

# Dependency checks
for cmd in rg sd xargs; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: required command '$cmd' not found on PATH." >&2
    exit 127
  fi
done

# Preview which files will be touched
echo "Scanning for matches under: $ROOT"
if ! rg -l "$SEARCH" "$ROOT" >/dev/null; then
  echo "No files contain a match for: $SEARCH"
  exit 0
fi

echo "Files to be modified:"
# Print list (newline delimited for readability)
rg -l "$SEARCH" "$ROOT"

# Perform replacement (NUL-delimited for safety)
echo
echo "Applying replacements..."
# -l0: NUL-delimited file list; -0: read NUL-delimited
rg -l0 "$SEARCH" "$ROOT" | xargs -0 sd "$SEARCH" "$REPLACE"

echo "Done."
