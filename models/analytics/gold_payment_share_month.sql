/*Card vs cash share by month*/
{{ config(materialized='table') }}

select
    extract(month from pickup_date) as month,
    payment_type,
    count(*) as trips,
    100.0 * count(*) / sum(count(*)) over (partition by extract(month from pickup_date)) as share_pct
from {{ ref('fact_trip') }}
group by month, payment_type
order by month, share_pct desc
