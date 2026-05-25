#!/usr/bin/env bash
# Install cursor-dotfiles into a project (macOS, Linux, Git Bash on Windows).
# Usage:
#   ./install.sh                    # current directory
#   ./install.sh /path/to/project
#   ./install.sh --skip-rules .     # skills only
#   ./install.sh --force .          # overwrite existing skill folders

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_RULES=0
FORCE=0
GLOBAL=0
TARGET="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-rules) SKIP_RULES=1; shift ;;
    --force) FORCE=1; shift ;;
    --global) GLOBAL=1; shift ;;
    -h|--help)
      echo "Usage: $0 [--global] [--skip-rules] [--force] [project-path]"
      echo "  --global   Install to ~/.cursor/skills and ~/.cursor/rules (all projects)"
      exit 0
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

resolve_target() {
  if [[ "$TARGET" == "." ]]; then
    pwd -P
  else
    cd "$TARGET" && pwd -P
  fi
}

if [[ "${GLOBAL}" -eq 1 ]]; then
  DEST_SKILLS="${HOME}/.cursor/skills"
  DEST_RULES="${HOME}/.cursor/rules"
  echo "Installing cursor-dotfiles globally into: ${DEST_SKILLS}"
else
  DEST="$(resolve_target)"
  DEST_SKILLS="${DEST}/.cursor/skills"
  DEST_RULES="${DEST}/.cursor/rules"
  echo "Installing cursor-dotfiles into: ${DEST}"
fi

SKILLS_SRC="${SCRIPT_DIR}/skills"
RULES_SRC="${SCRIPT_DIR}/rules"

mkdir -p "${DEST_SKILLS}"
mkdir -p "${DEST_RULES}"

installed=0
skipped=0

for src in "${SKILLS_SRC}"/*/; do
  [[ -d "$src" ]] || continue
  name="$(basename "$src")"
  dest="${DEST_SKILLS}/${name}"
  if [[ -d "$dest" ]] && [[ -f "${dest}/SKILL.md" ]] && [[ "${FORCE}" -eq 0 ]]; then
    echo "  [skip] skill: ${name} (exists, use --force to replace)"
    skipped=$((skipped + 1))
    continue
  fi
  if [[ "${FORCE}" -eq 1 ]] && [[ -d "$dest" ]]; then
    rm -rf "${dest}"
  fi
  # IMPORTANT (BSD/macOS cp): trailing slash on the source merges *contents*
  # into the destination folder, silently flattening all skills. Avoid "$src/"
  cp -R "${SKILLS_SRC}/${name}" "${DEST_SKILLS}/"
  echo "  [ok]   skill: ${name}"
  installed=$((installed + 1))
done

if [[ "${SKIP_RULES}" -eq 1 ]]; then
  echo "Rules skipped (--skip-rules)."
else
  count=0
  for f in "${RULES_SRC}"/*.mdc; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    dest="${DEST_RULES}/${base}"
    if [[ -f "$dest" ]] && [[ "${FORCE}" -eq 0 ]]; then
      echo "  [skip] rule:  ${base} (exists, use --force to replace)"
      skipped=$((skipped + 1))
      continue
    fi
    cp "$f" "${DEST_RULES}/"
    echo "  [ok]   rule:  ${base}"
    count=$((count + 1))
  done
  if [[ "${count}" -eq 0 ]] && [[ "${FORCE}" -eq 0 ]]; then
    echo "  (no new rules copied; use --force to overwrite)"
  fi
fi

echo "Done. Skills: ${DEST_SKILLS} | Rules: ${DEST_RULES}"
