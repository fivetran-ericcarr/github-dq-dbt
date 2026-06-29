with source as (
    select * from {{ source('github', 'pull_request') }}
)

select
    id                  as pull_request_id,
    issue_id,
    base_repo_id        as base_repository_id,
    head_repo_id        as head_repository_id,
    base_user_id,
    head_user_id,
    base_ref,
    head_ref,
    merge_commit_sha,
    draft               as is_draft,
    created_at,
    updated_at,
    closed_at
from source
