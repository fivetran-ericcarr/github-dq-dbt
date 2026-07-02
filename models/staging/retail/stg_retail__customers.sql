-- Large customer master (~28k). "customer_id" is NOT unique (~143 dupes) —
-- the `unique` test intentionally FAILS to demonstrate the activation gate.
with source as (select * from {{ source('retail', 'customers') }})
select
    "customer_id"       as customer_id,
    "customer_name"     as customer_name,
    "loyalty_segment"   as loyalty_segment,
    "units_purchased"   as units_purchased,
    "region"            as region,
    "state"             as state,
    "city"              as city
from source
