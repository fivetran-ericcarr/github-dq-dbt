{{ config(materialized='table') }}

-- Required by the dbt Semantic Layer (MetricFlow). Snowflake-native daily spine.
select dateadd(day, seq4(), to_date('2020-01-01'))::date as date_day
from table(generator(rowcount => 3653))
