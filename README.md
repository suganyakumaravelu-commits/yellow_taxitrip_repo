**Yellow Taxi Trip Lakehouse (Jan–Mar 2024)**

**Repository:** https://github.com/suganyakumaravelu-commits/yellow_taxitrip_repo

This project implements a small analytics lakehouse for NYC Yellow Taxi trips using dbt + DuckDB, following a clean Raw → Silver → Gold modelling pattern. It ingests month partitioned TLC trip data from S3, applies cleaning rules, builds a star schema, and produces analyst friendly KPIs.

**S3 Bucket & File Details**

        •	Bucket Name   yellow-taxi-trip-2024
        
        •	AWS Region       eu-west-2 (London)
        
        •	Bucket Console  URL https://eu-west-2.console.aws.amazon.com/s3/buckets/yellow-taxi-trip-2024?region=eu-west-2


Files Stored in S3. S3 Paths Used in dbt Models
**File Name	Format	Size	Uploaded	Notes**
taxi_zone_lookup.csv	CSV	12 KB	Jul 1, 2026	Zone → Borough lookup
yellow_tripdata_2024-01.parquet	Parquet	47.6 MB	Jul 1, 2026	January trips
yellow_tripdata_2024-02.parquet	Parquet	48.0 MB	Jul 1, 2026	February trips
yellow_tripdata_2024-03.parquet	Parquet	57.3 MB	Jul 1, 2026	March trips
yellow_tripdata_2024-04.parquet	Parquet	56.4 MB	Jul 1, 2026	April trips (used for incremental demo)

**Raw models read directly from S3 using DuckDB’s S3 API:**
•	s3://yellow-taxi-trip-2024/yellow_tripdata_2024-01.parquet
•	s3://yellow-taxi-trip-2024/yellow_tripdata_2024-02.parquet
•	s3://yellow-taxi-trip-2024/yellow_tripdata_2024-03.parquet
•	s3://yellow-taxi-trip-2024/yellow_tripdata_2024-04.parquet
•	s3://yellow-taxi-trip-2024/taxi_zone_lookup.csv

**IAM User & Permissions ** (dbtuser)
To allow dbt + DuckDB to read S3 files, an IAM user named dbtuser was created.

I.	Steps Performed

    1. Create IAM User
        •	IAM → Users → Create user
        •	Username: dbtuser
        
    2. Attach S3 Read Policy
        In Permissions → Add Permissions → Attach Policies:
        AmazonS3ReadOnlyAccess
        This allows dbtuser to:
            •	List bucket contents
            •	Read objects
            •	Use S3 API calls required by DuckDB         
    3. Generate Access Keys
        IAM → dbtuser → Security Credentials → Create Access Key
        You receive:
        •	Access Key ID
        •	Secret Access Key
        Important: AWS shows the Secret Key only once. It must be downloaded and stored securely.

    4. Set Credentials in Windows Environment
                   •	setx AWS_ACCESS_KEY_ID "<your-access-key-id>"
                   •	setx AWS_SECRET_ACCESS_KEY "<your-secret-access-key>"
            Restart terminal → activate venv → run dbt.
            dbt automatically picks up these credentials
            DuckDB’s httpfs extension uses them to authenticate S3 reads.

**Project Structure**

                yellow_taxitrip_repo/
                
                models/
                
                raw/                # Raw S3 ingestion models
                
                staging/            # Silver cleaned models
                
                marts/              # Gold star schema 
                
                analytics/          # Analyst-friendly SQL queries + KPI tables
                
                tests/
                
                data_quality_checks.sql
                
                schema.yml          # dbt tests
                
                data/
                
                nyc_taxi.duckdb
                
                README.md  
                
                ERD.md 
                


**II.	Setup Instructions**

**1. Clone the repo**

        •	git clone https://github.com/suganyakumaravelu-commits/yellow_taxitrip_repo.git

        •	cd yellow_taxitrip_repo

**2. Create Python 3.11 virtual environment**
py -3.11 -m venv venv
venv\Scripts\activate.bat
**3. Install dbt-duckdb**
pip install dbt-core==1.6.0
pip install dbt-duckdb==1.6.0
**4. Create DuckDB database file**
python -c "import duckdb; duckdb.connect('data/nyc_taxi.duckdb').close()"
**5. Create dbt_project.yml and requirement.txt files in the project. **
   Also initialize the .dbt folder -> .profiles.yml file
Eg: .dbt/.profiles.yml
yellow_taxitrip_repo:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: C:/Users/sugan/yellow_taxitrip_repo/data/nyc_taxi.duckdb
      schema: analytics
      threads: 4
      extensions:
        - httpfs
        - parquet
      settings:
        s3_region: "eu-west-2"
        s3_access_key_id: "{{ env_var('AWS_ACCESS_KEY_ID') }}"
        s3_secret_access_key: "{{ env_var('AWS_SECRET_ACCESS_KEY') }}"
**6. Configure AWS credentials**
setx AWS_ACCESS_KEY_ID "<your-access-key>"
setx AWS_SECRET_ACCESS_KEY "<your-secret-key>"
Restart terminal → activate venv again.
**7. Raw Layer**
Located in: models/raw/
•	Jan–Mar trip data
raw_yellow_tripdata_2024_01.sql
raw_yellow_tripdata_2024_01.sql
raw_yellow_tripdata_2024_01.sql
•	Zone lookup (raw_taxi_zone_lookup.sql)
•	April data for incremental (raw_yellow_tripdata_2024_04.sql)
•	Union model: raw_yellow_tripdata_2024_jan_mar.sql
**8. Silver Layer (staging)**
Located in: models/staging/silver_yellow_tripdata.sql
Cleaning rules implemented:
•	Standardised timestamps
•	Derived fields
•	Duration calculation
•	Deduplication
•	Range checks
•	Referential integrity
•	Removal of invalid rows
**9. Gold Layer (marts)**
Located in: models/marts/
Includes:
•	dim_zone
•	dim_date
•	fact_trip
**10. Analytics SQL Queries**
Located in: models/analytics/
•	KPI tables:
o	daily metrics
o	top O–D pairs
o	tip-rate by borough & hour
o	payment share by month
These are analyst-friendly SQL files that directly query gold tables.
**Sample Queries – **
1.	Daily metrics
select * from analytics.gold_daily_metrics order by pickup_date;
2.	Top O–D pairs
select * from analytics.gold_top_od_pairs_month;
3.	Tip-rate by borough & hour
select * from analytics.gold_tip_rate_by_borough_hour;
4.	Payment share
select * from analytics.gold_payment_share_month;

**11. Run dbt**
dbt debug
dbt run
dbt test
**12.  Data Quality Tests**
**dbt tests (tests/schema.yml)**
•	not_null
•	accepted_values
•	relationships
•	basic integrity checks
**SQL tests (tests/data_quality_checks.sql)**
Fail-fast checks for:
•	nulls
•	ranges
•	referential integrity
•	duplicates
•	timestamp logic


**IV.	What I’d Do Next (If I Had More Time)**
•	Incremental Load Design (Adding April 2024)
Incremental silver model
{{ config(
    materialized='incremental',
    unique_key='pickup_ts',
    incremental_strategy='delete+insert'
) }}
**Watermark strategy : ** We can use max(pickup_date) to load only new rows.
•	Add HVFHV dataset
•	Add freshness tests
•	Add orchestration (Dagster/Airflow)
•	Add dashboards (Evidence)
•	Add MERGE logic for late-arriving rows
•	Add partition pruning


**ERD Explanation**
The data model follows a simple star schema, designed to make taxi‑trip analytics fast, intuitive, and easy for business users to work with.

**1. fact_trip — the core table**
This is the central table that contains one row per taxi trip.
It stores all the important measures analysts care about:

trip distance

fare and total amount

tip amount

trip duration

pickup and drop‑off timestamps

payment type

passenger count

Think of fact_trip as the “transaction ledger” for all taxi rides.

**2. dim_zone — where trips happened**
This dimension translates numeric location IDs into meaningful business attributes:

Zone name

Borough (e.g., Manhattan, Brooklyn, Queens)

It allows analysts to answer questions like:

“Which borough generates the most trips?”

“What are the busiest pickup zones?”

“Where do high‑tip rides originate?”

Both pickup and drop‑off locations in fact_trip link to dim_zone, enabling origin–destination analysis.

**3. dim_date — when trips happened**
This dimension enriches each trip with calendar attributes:

year, month, day

day of week

weekend flag

It supports time‑based reporting such as:

daily trip volumes

month‑over‑month trends

weekday vs weekend patterns

How the tables work together
fact_trip connects to dim_zone twice:

once for pickup zone

once for drop‑off zone

fact_trip connects to dim_date through the pickup date

Together, these relationships allow analysts to slice and explore trip data by time, location, and business metrics.

Why this design matters
This star schema is intentionally simple and business‑friendly:

Analysts can understand it quickly

BI tools (Power BI, Tableau, Looker) work naturally with it

Queries run efficiently because dimensions are small and fact tables are partitioned by date

It supports all required KPIs:

daily metrics

top origin–destination pairs

tip‑rate by borough and hour

payment‑type share

In short, the ERD provides a clean, scalable foundation for mobility analytics.
