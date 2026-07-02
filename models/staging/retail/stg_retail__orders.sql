with source as (select * from {{ source('retail', 'ret_orders') }})
select
    id                  as order_id,
    order_user_id       as customer_id,
    amount,
    status              as order_status,
    cancel_return_reason,
    created_at          as order_created_at
from source
