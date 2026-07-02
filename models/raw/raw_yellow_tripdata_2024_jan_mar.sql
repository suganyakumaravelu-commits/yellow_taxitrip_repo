{{ config(materialized='table') }}

select * from {{ ref('raw_yellow_tripdata_2024_01') }}
union all
select * from {{ ref('raw_yellow_tripdata_2024_02') }}
union all
select * from {{ ref('raw_yellow_tripdata_2024_03') }}