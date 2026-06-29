# github_dq — dbt project

Hand-built dbt staging + Data Quality test layer over **GitHub** data replicated
by **Fivetran** into Snowflake (`ERICC_TEST_DB.github`). Companion to the
[metadata-service](https://github.com/fivetran-ericcarr/metadata-service)
end-to-end reference build.

## What it does

- Defines a `github` source (`_github__sources.yml`) with **source freshness**
  on `_fivetran_synced`.
- Builds 8 staging models over the core GitHub entities: `repository`, `user`,
  `issue`, `pull_request`, `issue_comment`, `label`, `milestone`,
  `pull_request_review`.
- Applies Data Quality tests (`_github__staging.yml`):
  - `not_null` + `unique` on every primary key
  - `relationships` across entities (repo/issue/PR/user/milestone) — referential
    checks that may legitimately warn where source data has gaps
  - `accepted_values` on `issue.state`, `milestone.state`, and review `state`

These are exactly the tests the `metadata-service` recommends from Fivetran +
dbt metadata, made concrete.

## Run

Configured in dbt Cloud (account 3643, project `ericc_transformations_test`)
against a Snowflake connection reading `ERICC_TEST_DB`.

```bash
dbt deps      # (no packages required)
dbt build     # runs models + tests
dbt source freshness
```
