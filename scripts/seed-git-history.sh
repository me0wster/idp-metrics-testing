#!/usr/bin/env bash
# Backdated commits + issue keys for Insights SCM / linking tests.
# Run from repo root. Safe to re-run on a fresh branch only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "Not a git repository." >&2
  exit 1
fi

commit_at() {
  local days_ago="$1"
  local message="$2"
  local file="$3"
  local content="$4"
  local date
  date=$(date -u -v-"${days_ago}"d +"%Y-%m-%dT12:00:00" 2>/dev/null || date -u -d "${days_ago} days ago" +"%Y-%m-%dT12:00:00")

  mkdir -p "$(dirname "$file")"
  echo "$content" >"$file"
  git add "$file"

  GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" \
    git commit -m "$message" --allow-empty 2>/dev/null || \
    GIT_AUTHOR_DATE="$date" GIT_COMMITTER_DATE="$date" \
      git commit -m "$message"
}

echo "Seeding git history (METRICS-* issue keys, last 30 days)..."

commit_at 28 "METRICS-101: add greeting module" \
  "src/index.js" \
  'function greet(name) { return `Hello, ${name}`; }
module.exports = { greet };'

commit_at 25 "METRICS-102: fix edge case in greet" \
  "src/index.js" \
  'function greet(name) {
  if (!name) return "Hello, world";
  return `Hello, ${name}`;
}
module.exports = { greet };'

commit_at 21 "METRICS-103: add unit tests" \
  "src/index.test.js" \
  "const { describe, it } = require('node:test');
const assert = require('node:assert');
const { greet } = require('./index.js');
describe('greet', () => {
  it('works', () => assert.equal(greet('insights'), 'Hello, insights'));
});"

commit_at 18 "METRICS-104: document testing harness" \
  "docs/changelog.md" \
  "# Changelog

- METRICS-101 through METRICS-104 seeded for IDP insights verification."

commit_at 14 "METRICS-105: bump package metadata" \
  "package.json" \
  '{
  "name": "idp-metrics-testing",
  "version": "0.1.1",
  "private": true,
  "description": "Fixture repository for IDP Development Insights metrics verification",
  "scripts": { "test": "node --test src/index.test.js" }
}'

commit_at 10 "METRICS-106: closes METRICS-102 — incident follow-up" \
  "docs/runbook.md" \
  "# Runbook

Production deploy verified via deploy-to-production workflow."

commit_at 7 "METRICS-107: requirement delivery checkpoint" \
  "docs/requirements.md" \
  "# Requirements

METRICS-103 delivered (tests)."

commit_at 3 "METRICS-108: routine maintenance" \
  "src/index.js" \
  'function greet(name) {
  if (!name) return "Hello, world";
  return `Hello, ${name}!`;
}
module.exports = { greet };'

commit_at 1 "METRICS-109: prepare release" \
  "docs/changelog.md" \
  "# Changelog

- METRICS-101 through METRICS-109 seeded for IDP insights verification.
- Ready for PR / deploy metrics testing."

echo ""
echo "Done. Push to GitHub:"
echo "  git push origin main"
echo ""
echo "Optional — open sample PRs:"
echo "  ./scripts/create-sample-prs.sh"
