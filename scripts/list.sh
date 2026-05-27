#!/usr/bin/env bash
set -euo pipefail

# Lists every SKILL.md in the repo with its name and description.

REPO="$(cd "$(dirname "$0")/.." && pwd)"

find "$REPO/skills" -name SKILL.md -print0 |
while IFS= read -r -d '' skill_md; do
  rel="${skill_md#$REPO/}"
  name="$(awk '/^name:/ {sub(/^name:[[:space:]]*/, ""); print; exit}' "$skill_md")"
  desc="$(awk '/^description:/ {sub(/^description:[[:space:]]*/, ""); print; exit}' "$skill_md")"
  echo "• $name"
  echo "    path: $rel"
  echo "    description: $desc"
  echo
done
