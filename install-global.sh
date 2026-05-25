#!/usr/bin/env bash
# Install cursor-dotfiles globally (~/.cursor/skills + ~/.cursor/rules).
# Usage: ./install-global.sh [--force] [--skip-rules]
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/install.sh" --global "$@"
