with source as (
    select * from {{ source('github', 'pull_request_review') }}
)

select
    id                  as pull_request_review_id,
    pull_request_id,
    user_id,
    state,
    commit_sha,
    body,
    submitted_at
from source
