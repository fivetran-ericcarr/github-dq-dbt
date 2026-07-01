# github_dq — dbt project

Hand-built dbt project over **GitHub** data replicated by **Fivetran** into
Snowflake (`ERICC_TEST_DB.github`). Companion to the
[metadata-service](https://github.com/fivetran-ericcarr/metadata-service)
end-to-end reference build — it exercises the dbt Platform features the
metadata-service surfaces (tests, freshness, lineage, exposures, Semantic Layer,
governance).

## What it does

- Defines a `github` source (`_github__sources.yml`) with **source freshness** on
  `_fivetran_synced`.
- **7 staging models** over the core GitHub entities: `repository`, `user`, `issue`,
  `pull_request`, `issue_comment`, `label`, `pull_request_review`.
- A **mart**, `github__repository_issue_summary` (one row per repo), with an
  **enforced contract**, an owner, a `group`, and `access: public`.
- A **Semantic Layer**: a `repository_issues` semantic model + three metrics
  (`total_open_issues`, `total_issues`, `open_issue_rate`) and a
  `metricflow_time_spine`.
- Two **exposures**: a *Repo Health* dashboard and an *Issue Triage* ML model.
- **Data Quality tests**: `not_null` + `unique` on primary keys, `relationships`
  across entities (some `warn` where source data has gaps), and `accepted_values`
  on the `state` fields.

These make concrete exactly what the metadata-service extracts and reasons over —
including the exposures/blast-radius, metric-trust, column-lineage, and governance
value-adds.

## Run

Configured in dbt Cloud (account 3643, project `ericc_transformations_test`)
against a Snowflake connection reading `ERICC_TEST_DB`.

```bash
dbt deps      # (no packages required)
dbt build     # runs models + tests
dbt source freshness
```
