- What is Spark?
    - Engine = Processes data
    - Distributed = Can distribute tasks to different machines within a cluster
    - Multi-language = Scala (native), Java, Python (PySpark)
    - Used when SQL is reaching its limitation. e.g. more complex transformation

- Why Spark?
    1. Scalability: PySpark is designed to handle large data sets that cannot fit into the memory of a single machine. It can distribute the data across multiple machines and perform parallel processing, which can greatly speed up data processing and analysis.
    2. Performance: PySpark is built on top of Apache Spark, which is optimized for big data processing. It can process data much faster than pure Python, especially when dealing with large data sets.
    3. Ease of use: PySpark provides a high-level API that is similar to SQL, which makes it easy for users with SQL experience to get started. It also provides many built-in functions for common data operations, which can simplify data processing and analysis tasks.
    4. Flexibility: Spark is built on top of Python, so you can use Python's rich ecosystem of libraries for data analysis and visualization, such as Pandas, Matplotlib, and Scikit-learn.
    5. Integration: PySpark can integrate with many other big data tools and technologies, such as Hadoop, Hive, and Cassandra. It can also run on various cloud platforms, such as Amazon Web Services (AWS) and Google Cloud Platform (GCP).

- How to install (py)Spark?
    - JDK 8 or 11 needed
        - Download via `wget` from java website
        - Unpack via `tar xzvf`
        - `JAVA_HOME` variable needed for spark, and adding it to the executable path
            - `export JAVA_HOME="${HOME}/spark/jdk-11.0.2"`
            - `export PATH="${JAVA_HOME}/bin:${PATH}"`
    - Spark
        - Download a bit of an older version + `Pre-buil for Apache Hadoop 3.2 and later` package type, via `wget`
        - Same for spark as with Java:
            - `export SPARK_HOME="${HOME}/spark/spark-3.2.3-bin-hadoop3.2"`
            - `export PATH="${SPARK_HOME}/bin:${PATH}"`
    - Add these 4 lines to `.bashrc` file to persist the variables after startup
        - `source .bashrc` = re-evaluate the startup file
    
- How to run PySpark
    - `export PYTHONPATH="${SPARK_HOME}/python/:$PYTHONPATH"`
    - `export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.9.5-src.zip:$PYTHONPATH"`
        - Check for exact py4j version and adapt
        - Add to bashrc
        
    - Start a jupyter notebook and check the ports
        
        ```jsx
        import pyspark
        from pyspark.sql import SparkSession     # to create connection to spark
        
        spark = SparkSession.builder \           # starting a spark session
            .master("local[*]") \                # local cluster, [*] = use all CPUs, [2] = use 2 CPUs
            .appName('test') \                   # name of app
            .getOrCreate()
        
        df = spark.read \
            .option("header", "true") \          # confirm header
            .csv('taxi+_zone_lookup.csv')        # define which csv to load
        
        df.show()                                # show df
        ```
        
    - To run CLI commands in jupyter notebook, e.g. wget, use `!` infront of them
    - Access Spark interface at `http://localhost:4040/`
- Reading in CSVs / Parquets
    
    
    Read CSV
    
    - `spark.read.csv("csvfile")`
        - When reading in a CSV with spark, everything is a string ⚠️ use pandas detection of datatypes to use in spark
    
    Read schema from pandas (better detection) to use for spark 
    
    - create smaller subset csv, e.g. first 1000 rows = `!head -n 1001 bigfile.csv > smallerfile.csv`
    - read in with pandas = `df_pandas = pd.read_csv(”smallerfile.csv”)`
    - check pandas detected data types = `df_pandas.dtypes`
    - create spark df from pandas df = `spark.createDataFrame(df_pandas).schema`
    - Manual format the spark df (java fromat) correct python code schema (PySpark)
        - `from pyspark.sql import types`
        
        ```python
        schema = types.StructType([
            types.StructField('hvfhs_license_num', types.StringType(), True),
            types.StructField('dispatching_base_num', types.StringType(), True),
            types.StructField('pickup_datetime', types.TimestampType(), True),
            types.StructField('dropoff_datetime', types.TimestampType(), True),
            types.StructField('PULocationID', types.IntegerType(), True),
            types.StructField('DOLocationID', types.IntegerType(), True),
            types.StructField('SR_Flag', types.StringType(), True)
        ])
        ```
        
    - read in csv with `spark.read` and pass schema as parameter
    
    Read Parquet file
    
    - `spark.read.parquet("parquetfile")`
    
    Transform CSV to parquet:
    
    - `df.write.parquet(”name”)` = creates parquet file of csv
        - creates parquet file in name-folder and a success confirmation file
    
    Transform GZIP to CSV:
    
    ```python
    import gzip, shutil
    
    with gzip.open('fhvhv_tripdata_2021-01.csv.gz', 'r') as f_in, open('fhvhv_tripdata_2021-01.csv', 'wb') as f_out:
      shutil.copyfileobj(f_in, f_out)
    ```
    
    Transform Parquet to CSV:
    
    - https://sparkbyexamples.com/spark/spark-convert-parquet-file-to-csv-format/
- How does Spark work?
    - ⚠️ can operate in a Data Lake
    
    `df.repartition()`
    
    - Spark executors (machine) within a cluster pick up one partition (file) per executor (machine)
        - to not have too many idle executors, prefer to have many small partitions vs. one large
    - lazy command = actual repartition happens only when an action is triggered, e.g. write, etc.
    
    `spark.read_csv(”file1”,”file2”)`
    
    - Spark can create one data frame out of many files
    
    `from pyspark.sql import functions as F`
    
    - `F.to_date()` = takes a timestamp and omits the hour information, keeping only date
    
    `df.withColumn(’pickup_date’)` 
    
    - Adds a new column to data frame
    
    `user defined function`
    
    - define python function
    - `functionname = F.udf(functionname, returnType=types.StringType())`
        - define return type
    
    `df.withColumnRenamed('column name old', 'column name new')`
    
    - Renaes column name to specified new name
    
    `df_1.unionAll(df_2)`
    
    - unions (extends) df_1 with the rows of df_2 without header from df_2
    
    `df.createOrReplaceTempView(’view name’)`
    
    - Registers the table ‘view name’ in order to make it callable in a spark-SQL statement
    
    `df_result.coalesce(1).write.parquet('data/report/revenue/', mode='overwrite')`
    
    - Out of df_result (SQL query) = `df_result`
    - Join the results into 1 file = `coalesce(1)`
    - write it to parquet file if the file exists, overwrite it = `write.parquet('destination', mode='overwrite')`
    
    - Spark Data Frames
        - ⚠️ parquets are smaller as they detect the column type better and apply the best compression
        - distributed dataset
    
    |  | Action | Transformation |
    | --- | --- | --- |
    | Execution | Immediate | Delayed |
    | Example | Show, Take, Head, Write | Select, Filtering, Join, Group by |
    | Behavior | Evaluates a command and runs it | Does not run the command |
- Anatomy of a spark cluster
    - Driver
        - Operator in Airflow or your local Laptop
        - Code files
    - Master
        - Every cluster (e.g. localhost://4040) has a Master
        - Coordinates the spark jobs to executors
        - Entry point to every spark cluster
        - Driver `Spark.submit` to send code to the master
    - Executors
        - Actually executing jobs
        - Multiples
        - Receives instructions from master
        - Each Executor pulls a partition - if dataframe has several partitions
    
    - Concept of Hadoop / HDFS setup (not popular anymore)
        - Sending source code to executor that already has the data
            - Previously data was stored in executors
        - Data redudancy (same partition stored on different executors) to preserve data in case a executor goes away
        - Today S3 bucket / GCS same data center as spark cluster
            - Executor pulls data from data lake and store back to data lake
- Group by in Spark
    1. A executor runs a complete SQL query on a partition, giving us multiple intermediate-result
        - Filtering (`Where`) and `Group by` in each partition
    2. Reshuffling || External merge sort
        - Intermediate result rows are moved = `reshuffled`
        - All intermediate-results with the same key (where Groupy By is used on) end up on a same (new) partition
        - Records in each (new) partition are now sorted
        - `Sums` / `Counts` are applied
        - Expensive operation = on as small amount of data as possible
- Joins in Spark
    1. Composite key
        - Composite key = the keys to join on
        - For every record, composite key is determined
    2. Reshuffling // External merge sort
        - Records with the same composite key go to the same partition
        - Reducing rows with same composite keys to one record
            - `Inner join` = Keep only records that have values in both datasets
            - `Outer join` = Keep records that have values in one dataset
    
    → If joining a small with a large table
    
    - Spark is `broadcasting` (copying) the small table to each executor
    - No need to reshulle
- RDDs in Spark
    
    
    |  | RDDs | DataFrame |
    | --- | --- | --- |
    | Naming | Resilient Distributed Datasets |  |
    | Structure | Collection of objects | Have Schema |
    | Spark relationship | Legacy | Are built on top of RDDs, internally still considered RDDs |
    - [How mapPartition is working in RDDs](https://www.youtube.com/watch?v=k3uB2K99roI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=53)
- Connecting from local Spark to GCS
    - Follow instructions in 09_spark_gcs.ipynb
    - Make sure that you have your google credentials for your account in the specified location
- Creating a local spark cluster
    - [Documentation](https://spark.apache.org/docs/latest/spark-standalone.html) & accompanying [video](https://www.youtube.com/watch?v=HXBwSlXo5IA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=55)
    - When turning a spark-notebook into a python-script, the master is defined outside of the script
        - via [spark-submit](https://spark.apache.org/docs/latest/submitting-applications.html)
- Setting up a Dataproc Cluster
    - Follow instructions in the [video](https://www.youtube.com/watch?v=osAiAYahvh8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=56) on the GC-UI
- Connecting Spark to BigQuery