
**Ingestion row counts (validated)**
    | Month | Rows |
    | --- | --- |
    | Jan 2024 | 2,964,624 |
    | Feb 2024 | 3,007,526 |
    | Mar 2024 | 3,582,628 |
    | Apr 2024 | 3,514,289 |

**Validate silver layer**
  Trip duration is negative 

    print(con.execute("select count(*) from analytics.silver_yellow_tripdata").fetchdf())
          >>> print(con.execute("""
          ... select count(*)
          ... from analytics.silver_yellow_tripdata
          ... where trip_duration_minutes <= 0
          ... """).fetchdf())
             
             count_star()
          0         64387

** ** Trip pickup or drop off time is null ****
 
            print(con.execute("""
            select count(*) 
            from analytics.silver_yellow_tripdata
            where pickup_ts is null or dropoff_ts is null
            """).fetchdf())
        
               count_star()
        0             0
