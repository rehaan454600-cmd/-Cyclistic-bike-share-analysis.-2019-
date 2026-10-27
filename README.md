# Cyclistic_bike_share_analysis.2019
**Cyclistic bike-share case study**: how casual riders and annual members use bikes differently. Analysis of 3.8M rides from 2019 with MySQL and Tableau, plus recommendations to convert casual riders into members.

## Data
- Divvy 2019 trip data, Q1 to Q4 (public data made available by Motivate International Inc.; the company name Cyclistic is fictional)
- 3,818,004 rides in total
- Raw files are not included in this report because of their size. Download them from the official Divvy trip data source. <a href="https://divvy-tripdata.s3.amazonaws.com/index.html"> Raw Dataset (Analysis uses the data from all the quarters from 2019)

## Tools
- MySQL (import, cleaning, summary queries)
- Tableau (visualizations)
- PowerPoint (presentation)

## Questions
- How do annual members and casual riders use Cyclistic bikes differently?
- Why would casual riders buy Cyclistic annual memberships?

## Process
### 1. Import:
loaded the four quarterly CSVs into MySQL (`LOAD DATA LOCAL INFILE`), standardizing column names across quarters.
#### Creates the tables for Q1, Q2, Q3, Q3
```sql
--Creates the tables for Q1, Q2, Q3, Q3

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

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This code loads the data from local drive into SQL server. This specific code imports data from Divvy_Trips_2019_Q1.csv in local drive to q1_ 2019 table in SQL server. The same can be done for other tables by changing some lines of code. 

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
```    
### 2. Clean:
renamed `Subscriber` to `Member` and `Customer` to `Casual`, stored blank gender and birth year values as NULL, calculated ride length and weekday, and merged all `4 tables into one` for analysis.

### 3. Filter:
excluded 13 rides with negative duration and 1,849 rides longer than 24 hours (likely errors or unreturned bikes). 3,816,142 rides were used in the analysis.

### 4. Summarize:
wrote SQL queries for ride share, ride length, weekday, hour, month, quarter, station, age group, and gender.

### 5. Visualize:
built the charts and dashboard in Tableau.
