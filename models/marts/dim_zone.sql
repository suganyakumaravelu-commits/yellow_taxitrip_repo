{{ config(materialized='table') }}

select
    locationid as zone_id,
    zone,
    borough
from {{ ref('raw_taxi_zone_lookup') }}
