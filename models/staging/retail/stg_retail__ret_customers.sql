with source as (select * from {{ source('retail', 'ret_customers') }})
select
    id                  as customer_id,
    email,
    name                as customer_name,
    company_name,
    region,
    customer_start_date
from source
