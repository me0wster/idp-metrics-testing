#!/usr/bin/env bash
# Creates two sample PRs on GitHub (requires gh auth + push access).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! command -v gh >/dev/null 2>&1; then
  echo "Install GitHub CLI: https://cli.github.com/" >&2
  exit 1
fi

BASE="${1:-main}"

create_pr() {
  local branch="$1"
  local title="$2"
  local body="$3"
  local file="$4"
  local content="$5"

  git checkout "$BASE"
  git pull origin "$BASE" 2>/dev/null || true
  git checkout -B "$branch"

  mkdir -p "$(dirname "$file")"
  echo "$content" >"$file"
  git add "$file"
  git commit -m "$title"
  git push -u origin "$branch" --force

  gh pr create --title "$title" --body "$body" --base "$BASE" --head "$branch" || true
  echo "Created PR: $title"
}

create_pr "feature/METRICS-110-dashboard" \
  "METRICS-110: add dashboard placeholder" \
  "Implements METRICS-110 for insights PR cycle testing.

Fixes METRICS-110" \
  "src/dashboard.js" \
  "module.exports = { dashboard: { name: 'metrics-test' } };"

create_pr "feature/METRICS-111-review-flow" \
  "METRICS-111: tweak greeting copy" \
  "Small copy change for review-depth testing.

Related: METRICS-111" \
  "src/index.js" \
  'function greet(name) {
  if (!name) return "Hello, world";
  return `Hello, ${name}!!`;
}
module.exports = { greet };'

git checkout "$BASE"
echo ""
echo "Merge one PR via GitHub UI (or: gh pr merge --merge) then re-sync insights."
