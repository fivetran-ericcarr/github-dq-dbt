with source as (select * from {{ source('retail', 'ret_customers') }})
select
    "id"                    as customer_id,
    "email"                 as email,
    "name"                  as customer_name,
    "company_name"          as company_name,
    "region"                as region,
    "customer_start_date"   as customer_start_date
from source
