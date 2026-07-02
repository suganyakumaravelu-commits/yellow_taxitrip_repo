{{ config(materialized='table') }}

select *
from read_csv_auto('s3://yellow-taxi-trip-2024/taxi_zone_lookup.csv')
