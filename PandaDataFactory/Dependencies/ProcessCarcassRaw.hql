DROP TABLE Carcass;

CREATE EXTERNAL TABLE Carcass (SeqNum string, PlantID string, Sex string, HideColor string, Tag string, HCW string, ApproxLiveWT string, ApproxFarmWT string, FatDepth string, RibEyeArea string, PctKPH string, YieldGrade string, USDAGrade string, Marbling string, QualityGrade string, CAB string, Comments string, LiverAbcess string) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION 'wasb:///raw/carcass/'
TBLPROPERTIES ('skip.header.line.count'='5');

DROP TABLE CarcassProcessed;

CREATE TABLE CarcassProcessed (StudyID string, SeqNum string, PlantID string, Sex string, HideColor string, Tag string, HCW string, ApproxLiveWT string, ApproxFarmWT string, FatDepth string, RibEyeArea string, PctKPH string, YieldGrade string, USDAGrade string, Marbling string, QualityGrade string, CAB string, Comments string, LiverAbcess string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/carcass/';

INSERT OVERWRITE TABLE CarcassProcessed
SELECT SUBSTR(INPUT__FILE__NAME, LENGTH(INPUT__FILE__NAME) - 16, 5) AS StudyID, SeqNum, PlantID, Sex, HideColor, Tag, HCW, ApproxLiveWT, ApproxFarmWT, FatDepth, RibEyeArea, PctKPH, YieldGrade, USDAGrade, Marbling, QualityGrade, CAB, Comments, LiverAbcess
FROM Carcass
WHERE CAST(PlantID as int) IS NOT NULL;