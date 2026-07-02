{{ config(materialized='table') }}

with dates as (
    select
        pickup_date as date
    from {{ ref('silver_yellow_tripdata') }}
    group by pickup_date
)

select
    date,
    extract(year from date) as year,
    extract(month from date) as month,
    extract(day from date) as day,
    extract(dow from date) as day_of_week,
    case when extract(dow from date) in (6, 0) then true else false end as is_weekend
from dates
