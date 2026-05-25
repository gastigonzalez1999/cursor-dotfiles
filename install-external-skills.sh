#!/usr/bin/env bash
# Install third-party skills from GitHub into Cursor skills dir.
# Usage:
#   ./install-external-skills.sh              # ~/.cursor/skills
#   ./install-external-skills.sh /path/to/project/.cursor/skills

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST_SKILLS="${1:-${HOME}/.cursor/skills}"
mkdir -p "${DEST_SKILLS}"

install_skill() {
  local repo="$1"
  local subfolder="$2"
  local skill_name="$3"
  local target="${DEST_SKILLS}/${skill_name}"

  if [[ -d "$target" ]] && [[ -f "${target}/SKILL.md" ]]; then
    echo "  [skip] $skill_name (exists)"
    return
  fi

  echo "  Installing $skill_name from $repo..."
  local tmp
  tmp=$(mktemp -d)
  if ! git clone --depth=1 "https://github.com/${repo}" "$tmp" -q 2>/dev/null; then
    echo "  [fail] $skill_name — clone failed"
    rm -rf "$tmp"
    return
  fi
  if [[ -d "$tmp/${subfolder}" ]]; then
    rm -rf "$target"
    cp -R "$tmp/${subfolder}" "$target"
    echo "  [ok] $skill_name"
  else
    echo "  [fail] $skill_name — subfolder '$subfolder' not found"
  fi
  rm -rf "$tmp"
}

echo "Installing external skills into: ${DEST_SKILLS}"

install_skill "vercel-labs/agent-skills" "skills/react-native-skills" "vercel-react-native-skills"
install_skill "dpearson2699/swift-ios-skills" "skills/core-bluetooth" "core-bluetooth"

echo "Done."
