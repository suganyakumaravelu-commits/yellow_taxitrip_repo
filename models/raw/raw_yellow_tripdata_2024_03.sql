{{ config(materialized='table') }}

select *
from read_parquet('s3://yellow-taxi-trip-2024/yellow_tripdata_2024-03.parquet')


