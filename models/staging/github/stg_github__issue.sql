with source as (
    select * from {{ source('github', 'issue') }}
)

select
    id              as issue_id,
    number          as issue_number,
    repository_id,
    user_id,
    milestone_id,
    title,
    state,
    state_reason,
    locked          as is_locked,
    created_at,
    updated_at,
    closed_at
from source
