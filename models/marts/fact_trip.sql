{{ config(materialized='table') }}

select
    pickup_ts,
    pickup_date,
    pickup_hour,
    vendorid,
    passenger_count,
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount,
    trip_duration_minutes,
    pulocationid as pu_zone_id,
    dolocationid as do_zone_id,
    payment_type
from {{ ref('silver_yellow_tripdata') }}
