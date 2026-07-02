with source as (select * from {{ source('retail', 'ret_tickets') }})
select
    "id"                as ticket_id,
    "ticket_user_id"    as customer_id,
    "issue_type"        as issue_type,
    "status"            as ticket_status,
    "created_at"        as ticket_created_at
from source
