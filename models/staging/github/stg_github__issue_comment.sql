with source as (
    select * from {{ source('github', 'issue_comment') }}
)

select
    id          as issue_comment_id,
    issue_id,
    user_id,
    body,
    created_at,
    updated_at
from source
