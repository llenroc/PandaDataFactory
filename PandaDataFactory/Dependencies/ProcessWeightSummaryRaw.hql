DROP TABLE WeightRaw;

CREATE EXTERNAL TABLE WeightRaw (Payload string)
STORED AS TEXTFILE LOCATION 'wasb:///raw/weight/';

add file wasb:///lib/BeefBodyWeightSummaryPigUDF.exe;

DROP TABLE WeightSummaryProcessed;

CREATE TABLE WeightSummaryProcessed (StudyID string, Pen string, TRT string, Rep string, Ration string, ID string, IWT float, FWT float, ADG float)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/weightsummary/';

INSERT OVERWRITE TABLE WeightSummaryProcessed
SELECT TRANSFORM (INPUT__FILE__NAME, *) USING 'BeefBodyWeightSummaryPigUDF.exe' AS
(StudyID string, Pen string, TRT string, Rep string, Ration string, ID string, IWT float, FWT float, ADG float)
FROM WeightRaw;