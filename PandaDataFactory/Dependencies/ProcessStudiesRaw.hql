DROP TABLE Studies;

CREATE EXTERNAL TABLE Studies (SpeciesGroup string, StudyType string, StudyNumber string, StudyDirector string, StartDate string, EndDate string, Title string, FarmLocation string, FeedingType string, AnimalType string, NumberOfAnimals string, TransitionID string, Status string) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION 'wasb:///raw/studies/'
TBLPROPERTIES ('skip.header.line.count'='1');

DROP TABLE StudiesProcessed;

CREATE TABLE StudiesProcessed (SpeciesGroup string, StudyID string, StudyDirector string, StartDate string, EndDate string, Title string, FarmLocation string, FeedingType string, AnimalType string, NumberOfAnimals string, TransitionID string, Status string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/studies/';

INSERT OVERWRITE TABLE StudiesProcessed
SELECT SpeciesGroup, CONCAT(StudyType, StudyNumber) AS StudyID, StudyDirector, StartDate, EndDate, Title, FarmLocation, FeedingType, AnimalType, NumberOfAnimals, TransitionID, Status
FROM Studies;
