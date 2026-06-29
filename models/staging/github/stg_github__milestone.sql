with source as (
    select * from {{ source('github', 'milestone') }}
)

select
    id              as milestone_id,
    number          as milestone_number,
    repository_id,
    creator_id,
    title,
    description,
    state,
    is_deleted,
    created_at,
    updated_at,
    closed_at,
    due_on
from source
