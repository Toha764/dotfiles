#!/usr/bin/env bash

# Usage: ./apply.sh <mac|linux> [--dry-run]

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="${1:?Usage: $0 <mac|linux> [--dry-run]}"
DRY_RUN="${2:+"-n"}"

if ! command -v stow &>/dev/null; then
  echo "stow is not installed" >&2
  exit 1
fi

stow_all() {
  local dir="$1"
  for pkg in "$dir"/*/; do
    [[ -d "$pkg" ]] || continue
    stow $DRY_RUN --dir="$dir" --target="$HOME" "$(basename "$pkg")"
  done
}

stow_all "$DOTFILES/os-specific/$OS"
stow_all "$DOTFILES/os-agnostic"
