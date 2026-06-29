with source as (
    select * from {{ source('github', 'repository') }}
)

select
    id              as repository_id,
    owner_id,
    name            as repository_name,
    full_name       as repository_full_name,
    description,
    language,
    default_branch,
    homepage,
    private         as is_private,
    fork            as is_fork,
    archived        as is_archived,
    watchers_count,
    forks_count,
    created_at
from source
