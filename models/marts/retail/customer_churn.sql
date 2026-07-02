-- Customer churn scoring — the activation source for the reverse-ETL demo.
-- One row per retail customer, enriched with order/return/ticket signals.
with customers as (
    select * from {{ ref('stg_retail__ret_customers') }}
),

orders as (
    select
        customer_id,
        count(*)                                              as order_count,
        sum(amount)                                           as total_spend,
        count_if(order_status in ('returned', 'cancelled'))   as returned_or_cancelled_orders,
        max(order_created_at)                                 as last_order_at
    from {{ ref('stg_retail__orders') }}
    group by 1
),

tickets as (
    select
        customer_id,
        count(*)                              as ticket_count,
        count_if(ticket_status <> 'closed')   as open_tickets
    from {{ ref('stg_retail__tickets') }}
    group by 1
),

joined as (
    select
        c.customer_id,
        c.email,
        c.customer_name,
        c.region,
        c.customer_start_date,
        o.order_count,
        o.total_spend,
        o.returned_or_cancelled_orders,
        o.last_order_at,
        t.ticket_count,
        t.open_tickets
    from customers c
    left join orders  o on c.customer_id = o.customer_id
    left join tickets t on c.customer_id = t.customer_id
),

scored as (
    select
        *,
        least(1.0,
              coalesce(returned_or_cancelled_orders, 0) * 0.15
            + coalesce(open_tickets, 0) * 0.20
            + case when last_order_at is null
                    or last_order_at < dateadd('day', -90, current_date())
                   then 0.40 else 0.0 end
        ) as churn_score
    from joined
)

select
    customer_id,
    email,
    customer_name,
    region,
    customer_start_date,
    datediff('day', customer_start_date, current_date()) as tenure_days,
    coalesce(order_count, 0)                    as order_count,
    coalesce(total_spend, 0)                    as total_spend,
    coalesce(returned_or_cancelled_orders, 0)   as returned_or_cancelled_orders,
    coalesce(ticket_count, 0)                   as ticket_count,
    coalesce(open_tickets, 0)                   as open_tickets,
    last_order_at,
    churn_score,
    case
        when last_order_at is null                              then 'prospect'
        when churn_score >= 0.6                                 then 'at_risk'
        when last_order_at < dateadd('day', -180, current_date()) then 'dormant'
        else 'active'
    end as lifecycle_stage
from scored
