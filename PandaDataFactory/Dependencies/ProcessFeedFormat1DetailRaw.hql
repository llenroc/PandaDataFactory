ADD JAR wasb:///lib/csv-serde-0.9.1.jar;

DROP TABLE FeedFormat1Detail;

CREATE EXTERNAL TABLE FeedFormat1Detail (StartDate string, EndDate string, StartTime string, EndTime string, Ration string, FI string, FO string, Count string, BC string) 
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
with serdeproperties (
   "separatorChar" = ",",
   "quoteChar"     = "\"")
STORED AS TEXTFILE LOCATION 'wasb:///raw/feed/feedformat1/'
TBLPROPERTIES ('skip.header.line.count'='3');

DROP TABLE IF EXISTS FeedFormat1DetailIntermediate;
CREATE TABLE FeedFormat1DetailIntermediate
(
  FileName string, StartDate date, EndDate date, StartTime string, EndTime string, Ration string, FI string, FO string, Count string, BC string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///intermediate/feedformat1detail/'; 

INSERT OVERWRITE TABLE FeedFormat1DetailIntermediate
SELECT INPUT__FILE__NAME, CAST(CONCAT(SUBSTR(StartDate, 7, 4), '-', SUBSTR(StartDate, 1, 2), '-', SUBSTR(StartDate, 4, 2)) as date) AS StartDate, CAST(CONCAT(SUBSTR(EndDate, 7, 4), '-', SUBSTR(EndDate, 1, 2), '-', SUBSTR(EndDate, 4, 2)) as date) AS EndDate, StartTime, EndTime, Ration, FI, FO, Count, BC
FROM FeedFormat1Detail;