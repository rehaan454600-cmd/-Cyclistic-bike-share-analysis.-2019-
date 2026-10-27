CREATE SCHEMA IF NOT EXISTS divvy_trips_2019;
USE divvy_trips_2019;

CREATE TABLE q1_2019 (
  trip_id           INT,
  start_time        DATETIME,
  end_time          DATETIME,
  bikeid            INT,
  tripduration      DECIMAL(10,1),
  from_station_id   INT,
  from_station_name VARCHAR(100),
  to_station_id     INT,
  to_station_name   VARCHAR(100),
  usertype          VARCHAR(20),
  gender            VARCHAR(10),
  birthyear         SMALLINT
);

CREATE TABLE q2_2019 LIKE q1_2019;
CREATE TABLE q3_2019 LIKE q1_2019;
CREATE TABLE q4_2019 LIKE q1_2019;

LOAD DATA LOCAL INFILE 'C:/Users/Rehaan Hasan/Desktop/data analysis/basic/projects/case study/bike share/csv/Divvy_Trips_2019_Q1.csv'
INTO TABLE q1_2019
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, start_time, end_time, bikeid, @td, from_station_id, from_station_name,
 to_station_id, to_station_name, usertype, @g, @by)
SET tripduration = REPLACE(@td, ',', ''),
    gender       = NULLIF(@g, ''),
    birthyear    = NULLIF(@by, '');
    
LOAD DATA LOCAL INFILE 'C:/Users/Rehaan Hasan/Desktop/data analysis/basic/projects/case study/bike share/csv/Divvy_Trips_2019_Q2.csv'
INTO TABLE q2_2019
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, start_time, end_time, bikeid, @td, from_station_id, from_station_name,
 to_station_id, to_station_name, usertype, @g, @by)
SET tripduration = REPLACE(@td, ',', ''),
    gender       = NULLIF(@g, ''),
    birthyear    = NULLIF(@by, ''); 
  
LOAD DATA LOCAL INFILE 'C:/Users/Rehaan Hasan/Desktop/data analysis/basic/projects/case study/bike share/csv/Divvy_Trips_2019_Q3.csv'
INTO TABLE q3_2019
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, start_time, end_time, bikeid, @td, from_station_id, from_station_name,
 to_station_id, to_station_name, usertype, @g, @by)
SET tripduration = REPLACE(@td, ',', ''),
    gender       = NULLIF(@g, ''),
    birthyear    = NULLIF(@by, ''); 
    
LOAD DATA LOCAL INFILE 'C:/Users/Rehaan Hasan/Desktop/data analysis/basic/projects/case study/bike share/csv/Divvy_Trips_2019_Q4.csv'
INTO TABLE q4_2019
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(trip_id, start_time, end_time, bikeid, @td, from_station_id, from_station_name,
 to_station_id, to_station_name, usertype, @g, @by)
SET tripduration = REPLACE(@td, ',', ''),
    gender       = NULLIF(@g, ''),
    birthyear    = NULLIF(@by, '');    