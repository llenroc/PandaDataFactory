DROP TABLE FeedProcessed;
CREATE TABLE FeedProcessed (StudyID string, Tag string, FeedDate string, Ration string, FeedInOut string, FeedInatke string)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LINES TERMINATED BY '10' STORED AS TEXTFILE LOCATION 'wasb:///processed/feed/';

INSERT INTO TABLE FeedProcessed
SELECT
	h.Exper,
	CASE
		WHEN d.Ration = "H" THEN
			CASE h.Calf
				WHEN 107 THEN 106
				WHEN 108 THEN 105
				WHEN 109 THEN 104
				WHEN 110 THEN 103
				WHEN 111 THEN 102
				WHEN 112 THEN 101
				WHEN 207 THEN 206
				WHEN 208 THEN 205
				WHEN 209 THEN 204
				WHEN 210 THEN 203
				WHEN 211 THEN 202
				WHEN 212 THEN 201
				WHEN 307 THEN 306
				WHEN 308 THEN 305
				WHEN 309 THEN 304
				WHEN 310 THEN 303
				WHEN 311 THEN 302
				WHEN 312 THEN 301
				WHEN 407 THEN 406
				WHEN 408 THEN 405
				WHEN 409 THEN 404
				WHEN 410 THEN 403
				WHEN 411 THEN 402
				WHEN 412 THEN 401
			ELSE
				h.Calf
			END
		ELSE
			h.Calf
	END AS Calf,
	--h.Ration AS HeaderRation,
	CASE
		WHEN CAST(SUBSTR(d.StartTime, 1, 2) AS int) < 12 THEN CAST(date_sub(d.StartDate, 1) AS date)
		ELSE d.StartDate
	END AS StartDate,
	d.Ration AS Ration,
	CASE
		WHEN d.FI <> "" THEN "In"
		WHEN d.FO <> "" THEN "Out"
		ELSE "Unknown"
	END AS FeedInOut,
	CASE
		WHEN d.FI <> "" THEN d.FI
		WHEN d.FO <> "" THEN d.FO * -1
		ELSE 0
	END AS FeedIntake
FROM FeedFormat1HeaderIntermediate h
JOIN FeedFormat1DetailIntermediate d ON d.FileName = h.FileName
WHERE d.FI = "" OR d.FO = "";

INSERT INTO TABLE FeedProcessed
SELECT
	h.Exper,
	CASE
		WHEN d.Ration = "H" THEN
			CASE h.Calf
				WHEN 107 THEN 106
				WHEN 108 THEN 105
				WHEN 109 THEN 104
				WHEN 110 THEN 103
				WHEN 111 THEN 102
				WHEN 112 THEN 101
				WHEN 207 THEN 206
				WHEN 208 THEN 205
				WHEN 209 THEN 204
				WHEN 210 THEN 203
				WHEN 211 THEN 202
				WHEN 212 THEN 201
				WHEN 307 THEN 306
				WHEN 308 THEN 305
				WHEN 309 THEN 304
				WHEN 310 THEN 303
				WHEN 311 THEN 302
				WHEN 312 THEN 301
				WHEN 407 THEN 406
				WHEN 408 THEN 405
				WHEN 409 THEN 404
				WHEN 410 THEN 403
				WHEN 411 THEN 402
				WHEN 412 THEN 401
			ELSE
				h.Calf
			END
		ELSE
			h.Calf
	END AS Calf,
  d.FeedDate,
  d.Ration,
  d.FeedType,
  d.FeedIntake
FROM FeedFormat2HeaderIntermediate h
JOIN FeedFormat2DetailIntermediate d ON d.FileName = h.FileName;