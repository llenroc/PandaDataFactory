ADD JAR wasb:///lib/csv-serde-0.9.1.jar;

DROP TABLE FeedFormat1Header;

CREATE EXTERNAL TABLE FeedFormat1Header (Exper string, Calf string, Sex string, StartDate string, Treat string, Rep string, Ration string, PenID string, GateID string) 
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
with serdeproperties (
   "separatorChar" = ",",
   "quoteChar"     = "\"")
STORED AS TEXTFILE LOCATION 'wasb:///raw/feed/feedformat1/'
TBLPROPERTIES ('skip.header.line.count'='1');

DROP TABLE IF EXISTS FeedFormat1HeaderIntermediate;

CREATE TABLE FeedFormat1HeaderIntermediate
(
  FileName string, Exper string, Calf string, Sex string, StartDate date, Treat string, Rep string, Ration string, PenID string, GateID string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///intermediate/feedformat1header/'; 

INSERT OVERWRITE TABLE FeedFormat1HeaderIntermediate
SELECT INPUT__FILE__NAME, Exper, Calf, Sex, CAST(CONCAT(SUBSTR(StartDate, 7, 4), '-', SUBSTR(StartDate, 1, 2), '-', SUBSTR(StartDate, 4, 2)) as date) AS StartDate, Treat, Rep, Ration, PenID, GateID
FROM FeedFormat1Header
WHERE CAST(Calf as int) IS NOT NULL;