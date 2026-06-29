with source as (
    select * from {{ source('github', 'user') }}
)

select
    id          as user_id,
    login       as user_login,
    name        as user_name,
    type        as user_type,
    company,
    location,
    blog,
    bio,
    site_admin  as is_site_admin,
    created_at,
    updated_at
from source
