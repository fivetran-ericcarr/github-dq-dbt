-- Large customer master (~28k rows). customer_id is NOT unique (~143 dupes) —
-- a real data-quality problem used to demonstrate the activation gate blocking.
with source as (select * from {{ source('retail', 'customers') }})
select
    customer_id,
    customer_name,
    loyalty_segment,
    units_purchased,
    region,
    state,
    city
from source
