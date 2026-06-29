with source as (
    select * from {{ source('github', 'label') }}
)

select
    id          as label_id,
    name        as label_name,
    description,
    color,
    is_default
from source
