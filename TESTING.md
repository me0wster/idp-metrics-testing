# IDP Insights — test harness

Use this repo with a local IDP instance to verify Development Insights end-to-end.

## Prerequisites

- IDP running: `pnpm dev` + `pnpm convex:dev` in the IDP repo
- GitHub App installed on **me0wster/idp-metrics-testing** with Pull request read access
- Catalog connector scoped to `me0wster` (user or org that owns the repo)

## Step 1 — Prepare this repository

```bash
cd /Users/tchin/Desktop/idp-metrics-testing
chmod +x scripts/*.sh
./scripts/seed-git-history.sh
git push origin main
```

Optional PR fixtures:

```bash
gh auth login   # if needed
./scripts/create-sample-prs.sh
# Merge at least one PR on GitHub for merged-PR metrics
```

## Step 2 — Catalog connector

1. **Dashboard → Connectors → New** (or use existing GitHub connector)
2. Scope: organization/user **`me0wster`**, include **idp-metrics-testing**
3. Run **Sync now** — catalog should discover a **Component** from `package.json`

## Step 3 — Enable insights sync

1. Open the catalog GitHub connector → **Development insights → Enable insights sync**
2. Streams: `repos`, `refs`, `commits`, `pullRequests`, `reviews`
3. **Sync now** on the insights connector
4. Confirm in Convex: `insightsRepos` contains `me0wster/idp-metrics-testing`

## Step 4 — Seed synthetic DORA data (IDP repo)

GitHub Actions runs are not ingested yet; use the Convex fixture seed for pipelines, issues, and DORA facts:

```bash
cd /Users/tchin/projects/self/idp
chmod +x scripts/seed-insights-test-fixtures.sh
./scripts/seed-insights-test-fixtures.sh
```

This creates:

- Classification rules (`deploy-to-production` → PRODUCTION; Bug/Story/Incident types)
- Fixture issues `METRICS-101` … `METRICS-103`
- Five successful `deploy-to-production` pipeline runs
- One deployment ↔ incident link (for change failure rate)
- Project group **idp-metrics-testing**
- DORA metric facts for the last 30 days

## Step 5 — Cross-domain linking

After GitHub sync + fixture seed:

1. **Insights → Mapping → Project groups → Auto-detect** (or confirm **idp-metrics-testing** group)
2. Check commits/PRs referencing `METRICS-*` in Convex `insightsCrossDomainLinks`

Commit messages from `seed-git-history.sh` include keys like `METRICS-101` for linker tests.

## Step 6 — Verify dashboards

| Dashboard | Path | Expect |
| --------- | ---- | ------ |
| DORA | Insights → Dashboards → Delivery Performance (DORA) | Five metrics with values for project group **idp-metrics-testing** |
| Classification | Insights → Classification | Deployment + issue type rules present |
| Mapping | Insights → Mapping | Repo linked to catalog component |

Time range: **Last 30 days**.

## Troubleshooting

| Problem | Fix |
| ------- | --- |
| `Repo not ingested yet` from seed script | Run insights **Sync now**, wait for `Ready` |
| DORA panels empty | Re-run `./scripts/seed-insights-test-fixtures.sh` |
| No cross-domain links | Ensure fixture issues exist; re-sync commits after seed |
| PR metrics empty | Run `create-sample-prs.sh` and merge a PR |

## Issue key convention

All fixtures use project key **`METRICS`**:

- `METRICS-101` — Bug (resolved)
- `METRICS-102` — Incident (linked to a deployment for CFR)
- `METRICS-103` — Story / requirement
- `METRICS-104` … `METRICS-109` — commit messages only (link when issues are added)
