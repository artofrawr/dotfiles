#!/bin/sh
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check that chezmoi is installed
if ! command -v chezmoi >/dev/null 2>&1; then
    echo "Error: chezmoi is not installed or not in PATH." >&2
    echo "Install it from https://www.chezmoi.io/install/" >&2
    exit 1
fi

# Initialize and apply
chezmoi init --apply --source="$SCRIPT_DIR"

echo ""
echo "COMPLETE: dotfiles initialized and applied"
echo ""
