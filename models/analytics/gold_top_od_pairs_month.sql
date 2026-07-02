/*Top 10 O–D pairs per month*/
{{ config(materialized='table') }}

select
    extract(month from pickup_date) as month,
    pu_zone_id,
    do_zone_id,
    count(*) as trips,
    row_number() over (
        partition by extract(month from pickup_date)
        order by count(*) desc
    ) as rn
from {{ ref('fact_trip') }}
group by month, pu_zone_id, do_zone_id
qualify rn <= 10
