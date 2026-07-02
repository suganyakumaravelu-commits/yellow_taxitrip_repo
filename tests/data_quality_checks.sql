-- ============================================================
-- DATA QUALITY CHECKS FOR SILVER LAYER
-- These checks fail-fast and return rows that violate rules.
-- ============================================================

---------------------------------------------------------------
-- 1. Not-null timestamp check
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where pickup_ts is null
   or dropoff_ts is null;

---------------------------------------------------------------
-- 2. Not-null location IDs
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where pulocationid is null
   or dolocationid is null;

---------------------------------------------------------------
-- 3. Accepted payment_type values (TLC codes 1–6)
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where payment_type not in (1,2,3,4,5,6);

---------------------------------------------------------------
-- 4. Duration range check (0–300 minutes)
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where trip_duration_minutes < 0
   or trip_duration_minutes > 300;

---------------------------------------------------------------
-- 5. Distance range check (0–100 miles)
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where trip_distance < 0
   or trip_distance > 100;

---------------------------------------------------------------
-- 6. Referential integrity: PU location must exist in dim_zone
---------------------------------------------------------------
select s.*
from analytics.silver_yellow_tripdata s
left join analytics.dim_zone z
       on s.pulocationid = z.zone_id
where z.zone_id is null;

---------------------------------------------------------------
-- 7. Referential integrity: DO location must exist in dim_zone
---------------------------------------------------------------
select s.*
from analytics.silver_yellow_tripdata s
left join analytics.dim_zone z
       on s.dolocationid = z.zone_id
where z.zone_id is null;

---------------------------------------------------------------
-- 8. Dropoff must be >= pickup
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where dropoff_ts < pickup_ts;

---------------------------------------------------------------
-- 9. Fare must be positive
---------------------------------------------------------------
select *
from analytics.silver_yellow_tripdata
where fare_amount <= 0;

---------------------------------------------------------------
-- 10. Duplicate detection (should be zero after dedup)
---------------------------------------------------------------
with dupes as (
    select
        vendorid,
        pickup_ts,
        dropoff_ts,
        pulocationid,
        dolocationid,
        total_amount,
        count(*) as cnt
    from analytics.silver_yellow_tripdata
    group by 1,2,3,4,5,6
    having count(*) > 1
)
select * from dupes;
