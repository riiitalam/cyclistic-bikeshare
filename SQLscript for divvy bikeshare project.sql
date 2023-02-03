/* Cyclistic (Divvy) Bikeshare Casestudy 
SQLite 3.12.2 is used for SQL codes execution for this project

/* Dataset's Metadata-
Data Source: Jan - Dec 2022 from Divvy Bikes (https://www.divvybikes.com/system-data)
Contains 13 columns - 
	"ride_id"	TEXT,
	"rideable_type"	TEXT,
	"started_at"	TEXT,
	"ended_at"	TEXT,
	"start_station_name"	TEXT,
	"start_station_id"	TEXT,
	"end_station_name"	TEXT,
	"end_station_id"	TEXT,
	"start_lat"	REAL,
	"start_lng"	REAL,
	"end_lat"	REAL,
	"end_lng"	REAL,
	"member_casual"	TEXT
*/

/* To merge all months' datasets into "202212-divvy-tripdata" */
INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202211-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202210-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202209-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202208-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202207-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202206-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202205-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202204-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202203-divvy-tripdata"

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202202-divvy-tripdata";

INSERT INTO "202212-divvy-tripdata"
SELECT *
FROM "202201-divvy-tripdata";

/* All months of 2022 data were merged into the "202212-divvy-tripdata" table
"202212-divvy-tripdata" now contains data from Jan 2022 to Dec 2022 */


/* Compile visualization table for data with ride length < 3 hours */
SELECT ride_id, started_at, ended_at, 
/* Calculate and add column of ride duration */
ROUND(((JULIANDAY(ended_at)-JULIANDAY(started_at))*24*60),1) as ride_duration, 
member_casual, rideable_type, start_lat, start_lng, end_lat, end_lng,
/* Classify day of week to be weekend or weekday and added as a new column */
CASE 
	WHEN strftime('%w', started_at) IN ("0","6")
	THEN "weekend"
	ELSE "weekday"
	END as weekend_day

FROM "202212-divvy-tripdata"
/* Limit data to which ride length is less than or equal to 3 hours */
WHERE ride_duration <= 180 AND ride_duration >= 0
/* Exclude Null values from data */
AND member_casual IS NOT NULL
AND ride_duration IS NOT NULL
AND end_lat IS NOT NULL
AND end_lng IS NOT NULL
AND start_lng IS NOT NULL
AND start_lng IS NOT NULL;

/* Compile visualization table for data with long ride length > 3 hours for separate analysis */

SELECT ride_id, started_at, ended_at, 
/* Calculate and add column of ride duration in hours and in days */
ROUND(((JULIANDAY(ended_at)-JULIANDAY(started_at))*24),2) as ride_duration_hr, 
ROUND(((JULIANDAY(ended_at)-JULIANDAY(started_at))),2) as ride_duration_day, 
member_casual, rideable_type, start_lat, start_lng, end_lat, end_lng,
/* Classify day of week to be weekend or weekday and added as a new column */
CASE 
	WHEN strftime('%w', started_at) IN ("0","6")
	THEN "weekend"
	ELSE "weekday"
	END as weekend_day

FROM "202212-divvy-tripdata"
/* Limit data to which ride length is greater than 3 hours */
WHERE ride_duration_hr > 3
/* Exclude Null vales from data */
AND member_casual IS NOT NULL
AND ride_duration_hr IS NOT NULL
AND end_lat IS NOT NULL
AND end_lng IS NOT NULL
AND start_lng IS NOT NULL
AND start_lng IS NOT NULL
/* To exclude the 4 outliers with abnormal ride duration > 400 hours*/
AND ride_duration_hr >400;

/* Rank member and casual rider's top 10 ride start stations based on number of usage */
WITH start_station_rank AS (
SELECT member_casual, start_station_name, COUNT(start_station_name) AS start_station_usage, start_lat, start_lng,
COUNT(CASE WHEN rideable_type='docked_bike' THEN 1 END) as docked_bike_usage,
COUNT(CASE WHEN rideable_type='classic_bike' THEN 1 END) as classic_bike_usage,
COUNT(CASE WHEN rideable_type='electric_bike' THEN 1 END) as electric_bike_usage,
RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC)as top_start_station
FROM "202212-divvy-tripdata"
GROUP BY member_casual, start_station_name
ORDER BY member_casual
)
SELECT member_casual, top_start_station, start_station_name, start_station_usage, 
electric_bike_usage, classic_bike_usage, docked_bike_usage, 
start_lat, start_lng
FROM start_station_rank
WHERE top_start_station <=10;

/* Rank member and casual rider's top 10 ride return stations based on number of usage */
WITH end_station_rank AS(

SELECT member_casual, end_station_name, COUNT(end_station_name) as end_station_usage, end_lat, end_lng,
COUNT(CASE WHEN rideable_type='docked_bike' THEN 1 END) as docked_bike_usage,
COUNT(CASE WHEN rideable_type='classic_bike' THEN 1 END) as classic_bike_usage,
COUNT(CASE WHEN rideable_type='electric_bike' THEN 1 END) as electric_bike_usage,
RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC)as top_end_station
FROM "202212-divvy-tripdata"
GROUP BY member_casual, end_station_name
ORDER BY member_casual
)
SELECT member_casual, top_end_station, end_station_name, end_station_usage, 
electric_bike_usage, classic_bike_usage, docked_bike_usage, 
end_lat, end_lng
FROM end_station_rank
WHERE top_end_station <=10;


/* Rank member and casual rider's top 10 routes from start station  to return station based on number of usage */
SELECT member_casual, top_route_rank, route, route_count, start_lat, start_lng, end_lat, end_lng, ride_id
FROM (
SELECT member_casual, start_station_name|| ' to ' || end_station_name as route, 
RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name|| ' to ' || end_station_name) DESC) as top_route_rank,
COUNT(start_station_name|| ' to ' || end_station_name) as route_count, start_lat, start_lng, end_lat, end_lng, ride_id
FROM "202212-divvy-tripdata"
GROUP BY member_casual, route
)
WHERE top_route_rank <=10
ORDER BY member_casual;

/* Create table for mapping member and casual rider's top 10 routes in Tableau */
WITH temp AS(SELECT ride_id, member_casual, route, end_lat , end_lng, route_count
FROM "top route 2022"),

main AS(SELECT ride_id, member_casual, route, start_lat as lat, start_lng as lng, route_count
FROM "top route 2022") 
SELECT * FROM main
UNION ALL
SELECT * FROM temp
ORDER BY member_casual, route_count DESC;
