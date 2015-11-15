DROP TABLE MBIRaw;

CREATE EXTERNAL TABLE MBIRaw (Payload string)
STORED AS TEXTFILE LOCATION 'wasb:///raw/mbi/';

add file wasb:///lib/MBIUDF.exe;

DROP TABLE MBIProcessed;

CREATE TABLE MBIProcessed (StudyID string, Tag string, TRT string, Rep string, ObservationDate string, HasMBI string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/mbi/';

INSERT OVERWRITE TABLE MBIProcessed
SELECT TRANSFORM (INPUT__FILE__NAME, *) USING 'MBIUDF.exe' AS
(StudyID string, Tag string, TRT string, Rep string, ObservationDate string, HasMBI string)
FROM MBIRaw;
