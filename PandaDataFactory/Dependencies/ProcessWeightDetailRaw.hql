DROP TABLE WeightRaw;

CREATE EXTERNAL TABLE WeightRaw (Payload string)
STORED AS TEXTFILE LOCATION 'wasb:///raw/weight/';

add file wasb:///lib/BeefBodyWeightDetailPigUDF.exe;

DROP TABLE WeightDetailProcessed;

CREATE TABLE WeightDetailProcessed (StudyID string, Pen string, Treatment string, Replication string, Ration string, Tag string, PeriodDate string, WT float, Period int, DaysInPeriod int, RunningDays int, ADG float)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/weightdetail/';

INSERT OVERWRITE TABLE WeightDetailProcessed
SELECT TRANSFORM (INPUT__FILE__NAME, *) USING 'BeefBodyWeightDetailPigUDF.exe' AS
(StudyID string, Pen string, Treatment string, Replication string, Ration string, Tag string, PeriodDate string, WT float, Period int, DaysInPeriod int, RunningDays int, ADG float)
FROM WeightRaw;