/*Tip-rate by borough & hour*/
{{ config(materialized='table') }}

select
    z.borough,
    pickup_hour,
    avg(case when tip_amount > 0 then 1.0 else 0.0 end) as tip_rate
from {{ ref('fact_trip') }} f
join {{ ref('dim_zone') }} z
  on f.pu_zone_id = z.zone_id
group by z.borough, pickup_hour
order by z.borough, pickup_hour
