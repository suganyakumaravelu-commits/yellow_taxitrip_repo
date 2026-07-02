{{ config(materialized='table') }}

with base as (
    select
        vendorid,
        tpep_pickup_datetime,
        tpep_dropoff_datetime,
        passenger_count,
        trip_distance,
        fare_amount,
        tip_amount,
        total_amount,
        pulocationid,
        dolocationid,
        payment_type
    from {{ ref('raw_yellow_tripdata_2024_jan_mar') }}
),

with_time as (
    select
        *,
        -- standardised timestamps
        cast(tpep_pickup_datetime as timestamp) as pickup_ts,
        cast(tpep_dropoff_datetime as timestamp) as dropoff_ts,
        date(pickup_ts) as pickup_date,
        extract(hour from pickup_ts) as pickup_hour,
        date_diff('minute', pickup_ts, dropoff_ts) as trip_duration_minutes
    from base
),

cleaned as (
    select
        *,
        -- simple de-dup key
        row_number() over (
            partition by vendorid,
                         pickup_ts,
                         dropoff_ts,
                         pulocationid,
                         dolocationid,
                         total_amount
            order by pickup_ts
        ) as dup_rank
    from with_time
)

select
    vendorid,
    pickup_ts,
    dropoff_ts,
    pickup_date,
    pickup_hour,
    passenger_count,
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount,
    pulocationid,
    dolocationid,
    payment_type,
    trip_duration_minutes
from cleaned
where dup_rank = 1
  and fare_amount > 0
  and trip_distance >= 0
  and trip_duration_minutes between 0 and 300
  and dropoff_ts >= pickup_ts
  and pulocationid is not null
  and dolocationid is not null
