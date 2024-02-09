SELECT COUNT(1)  FROM `de-zoomcamp-413000.green2022.green2022table` LIMIT 1000
-- 840402

CREATE OR REPLACE TABLE `de-zoomcamp-413000.green2022.green2022table-nonpartitioned`
AS SELECT * FROM `de-zoomcamp-413000.green2022.green2022table`

SELECT COUNT(DISTINCT(PULocationID)) FROM `de-zoomcamp-413000.green2022.green2022table-nonpartitioned`;
SELECT COUNT(1) FROM `de-zoomcamp-413000.green2022.green2022table-nonpartitioned`;

SELECT COUNT(DISTINCT(PULocationID))  FROM `de-zoomcamp-413000.green2022.green2022table` LIMIT 1000
-- 0 MB for the External Table and 6.41MB for the Materialized Table

SELECT COUNT(fare_amount)  FROM `de-zoomcamp-413000.green2022.green2022table` 
WHERE fare_amount = 0;
-- 1622 

CREATE OR REPLACE TABLE `de-zoomcamp-413000.green2022.green2022table-partitioned`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS (
  SELECT * FROM `de-zoomcamp-413000.green2022.green2022table`
);
-- Partition by lpep_pickup_datetime Cluster on PUlocationID

SELECT DISTINCT(PULocationID) FROM  `de-zoomcamp-413000.green2022.green2022table-nonpartitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

SELECT DISTINCT(PULocationID) FROM  `de-zoomcamp-413000.green2022.green2022table-partitioned`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

-- 12.82 MB for non-partitioned table and 1.12 MB for the partitioned table

