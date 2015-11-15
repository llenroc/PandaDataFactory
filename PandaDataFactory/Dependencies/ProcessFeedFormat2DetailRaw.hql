ADD JAR wasb:///lib/csv-serde-0.9.1.jar;

DROP TABLE FeedFormat2Detail;

CREATE EXTERNAL TABLE FeedFormat2Detail (FeedDate string, AMFI string, PMFI string, AddBack string, FO string)
row format serde 'com.bizo.hive.serde.csv.CSVSerde'
with serdeproperties (
   "separatorChar" = ",",
   "quoteChar"     = "\"")
STORED AS TEXTFILE LOCATION 'wasb:///raw/feed/feedformat2/'
TBLPROPERTIES ('skip.header.line.count'='3');

DROP TABLE IF EXISTS FeedFormat2DetailIntermediate;
CREATE TABLE FeedFormat2DetailIntermediate
(
  FileName string, FeedDate date, Ration string, FeedIntake float, FeedType string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///intermediate/feedformat2detail/'; 

-- FI
INSERT INTO TABLE FeedFormat2DetailIntermediate
SELECT
	INPUT__FILE__NAME,
	CAST(CONCAT(SUBSTR(FeedDate, 7, 4), '-', SUBSTR(FeedDate, 1, 2), '-', SUBSTR(FeedDate, 4, 2)) as date) AS FeedDate,
	CASE WHEN SPLIT(AMFI, "/")[1] = "G"
		THEN SPLIT(PMFI, "/")[1]
		ELSE SPLIT(AMFI, "/")[1]
	END AS Ration,
	CAST(SPLIT(AMFI, "/")[0] as float) + CAST(SPLIT(PMFI, "/")[0] as float) AS FeedIntake,
	"In" AS FeedType
FROM FeedFormat2Detail
WHERE AMFI IS NOT NULL;

-- FO
INSERT INTO TABLE FeedFormat2DetailIntermediate
SELECT
	INPUT__FILE__NAME,
	CAST(CONCAT(SUBSTR(FeedDate, 7, 4), '-', SUBSTR(FeedDate, 1, 2), '-', SUBSTR(FeedDate, 4, 2)) as date) AS FeedDate,
	CASE WHEN SPLIT(AMFI, "/")[1] = "G"
		THEN SPLIT(PMFI, "/")[1]
		ELSE SPLIT(AMFI, "/")[1]
	END AS Ration,
	CAST(FO as float) * -1 AS FeedIntake,
	"Out" AS FeedType
FROM FeedFormat2Detail
WHERE AMFI IS NOT NULL;

-- AddBack
INSERT INTO TABLE FeedFormat2DetailIntermediate
SELECT
	INPUT__FILE__NAME,
	CAST(CONCAT(SUBSTR(FeedDate, 7, 4), '-', SUBSTR(FeedDate, 1, 2), '-', SUBSTR(FeedDate, 4, 2)) as date) AS FeedDate,
	CASE WHEN SPLIT(AMFI, "/")[1] = "G"
		THEN SPLIT(PMFI, "/")[1]
		ELSE SPLIT(AMFI, "/")[1]
	END AS Ration,
	CAST(SPLIT(AddBack, "/")[0] as float) AS FeedIntake,
	"AddBack" AS FeedType
FROM FeedFormat2Detail
WHERE AMFI IS NOT NULL;
