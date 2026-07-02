/*Daily trips, revenue, avg fare per mile*/
{{ config(materialized='table') }}

select
    pickup_date,
    count(*) as total_trips,
    sum(total_amount) as total_revenue,
    avg(case when trip_distance > 0 then fare_amount / trip_distance end) as avg_fare_per_mile
from {{ ref('fact_trip') }}
group by pickup_date
order by pickup_date
