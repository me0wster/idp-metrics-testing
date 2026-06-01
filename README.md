# idp-metrics-testing

Fixture repository for verifying **IDP Development Insights** (feature `002-dev-insights`).

**GitHub:** [me0wster/idp-metrics-testing](https://github.com/me0wster/idp-metrics-testing)

## What this repo provides

| Signal | Source |
| ------ | ------ |
| SCM commits with `METRICS-*` issue keys | `scripts/seed-git-history.sh` |
| Pull requests for cycle-time metrics | `scripts/create-sample-prs.sh` |
| Production deploy workflow name | `.github/workflows/deploy-to-production.yml` |
| Catalog discovery probes | `package.json`, `README.md`, `.github/CODEOWNERS` |

Synthetic Jira issues, CI pipeline runs, and DORA metric facts are seeded in IDP via `scripts/seed-insights-test-fixtures.sh` (see [TESTING.md](./TESTING.md)).

## Quick start

```bash
# 1. Backdated commits (METRICS-101 … METRICS-109)
chmod +x scripts/*.sh
./scripts/seed-git-history.sh
git push origin main

# 2. Optional: open sample PRs (requires gh auth)
./scripts/create-sample-prs.sh

# 3. Follow TESTING.md to wire IDP connectors and seed Convex fixtures
```
