
**Ingestion row counts (validated)**

        >>> print(con.execute("select count(*) from analytics.raw_yellow_tripdata_2024_01").fetchdf())
           count_star()
        0       2964624
        >>> print(con.execute("select count(*) from analytics.raw_yellow_tripdata_2024_02").fetchdf())
           count_star()
        0       3007526
        >>> print(con.execute("select count(*) from analytics.raw_yellow_tripdata_2024_03").fetchdf())
           count_star()
        0       3582628
        >>> print(con.execute("select count(*) from analytics.raw_yellow_tripdata_2024_04").fetchdf())
           count_star()
        0       3514289

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
