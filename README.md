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
Loaded the four quarterly CSVs into MySQL (`LOAD DATA LOCAL INFILE`), standardizing column names across quarters.
#### SQL Code:
```sql
--Creates the tables for Q1, Q2, Q3, Q4
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
Renamed `Subscriber` to `Member` and `Customer` to `Casual`, stored blank gender and birth year values as NULL, calculated ride length and weekday, and merged all `4 tables into one` for analysis.
#### SQL Code:
```sql
USE divvy_trips_2019;

CREATE TABLE trips_summary AS
SELECT
  trip_id,
  start_time,
  end_time,
  ROUND(TIMESTAMPDIFF(SECOND, start_time, end_time)/60, 2)  AS ride_length_min,
  DAYNAME(start_time)                                       AS weekday_name,
  quarter_label,
  bikeid                                                    AS bike_id,
  from_station_id, from_station_name,
  to_station_id,   to_station_name,
  CASE TRIM(usertype)
    WHEN 'Subscriber' THEN 'Member'
    WHEN 'Customer'   THEN 'Casual'
    ELSE TRIM(usertype)
  END                                                       AS user_type,
  gender,
  birthyear
FROM (
  SELECT *, 'Q1' AS quarter_label FROM q1_2019
  UNION ALL
  SELECT *, 'Q2' FROM q2_2019
  UNION ALL
  SELECT *, 'Q3' FROM q3_2019
  UNION ALL
  SELECT *, 'Q4' FROM q4_2019
) AS all_trips;
```
### 3. Filter:
Excluded 13 rides with negative duration and 1,849 rides longer than 24 hours (likely errors or unreturned bikes). 3,816,142 rides were used in the analysis.
#### SQL Code:
```sql
SELECT
  trip_id,
  start_time,
  end_time,
  sec_to_time(TIMESTAMPDIFF(SECOND, start_time, end_time)/60, 2) AS ride_length_min
FROM divvy_trips_2019.q1_2019
LIMIT 10;
```

### 4. Analysis:
Analyzed 3.8M rides with SQL to compare member and casual rider behavior across time, duration, location, and demographics.
#### SQL Code:
```sql
--This code gives average_ride_min, total_ride_hours and percentage of Casial and Members 
SELECT user_type,
       COUNT(*)                                    AS rides,
       ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 1) AS per_of_rides,
       ROUND(AVG(ride_length_min),1)              AS avg_ride_min,
       ROUND(SUM(ride_length_min) / 60, 0)         AS total_ride_hours
FROM divvy_trips_2019.trips_summary
GROUP BY user_type;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This gives the average time for rides in weekdays
SELECT user_type, weekday_num, weekday_name,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, weekday_num, weekday_name
ORDER BY user_type, weekday_num;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This code is the same but for month
SELECT user_type, month_num, month_name,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, month_num, month_name
ORDER BY user_type, month_num;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--This code returns the average value of ride length and number of rides in that hour 
SELECT user_type, start_hour,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, start_hour
ORDER BY user_type, start_hour;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


--This is the same result from the last code but for heat map
SELECT user_type, weekday_num, weekday_name, start_hour, COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, weekday_num, weekday_name, start_hour
ORDER BY user_type, weekday_num, start_hour;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This lines of code makes it easy to classify number of ride and there duration 
SELECT user_type,
       CASE WHEN ride_length_min < 5  THEN '<5 min'
            WHEN ride_length_min < 10 THEN '5-10 min'
            WHEN ride_length_min < 20 THEN '10-20 min'
            WHEN ride_length_min < 30 THEN '20-30 min'
            WHEN ride_length_min < 60 THEN '30-60 min'
            ELSE '60 min +' END AS ride_duration,
       COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, ride_duration
ORDER BY user_type, ride_duration;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--It finds the top 15 start stations per user type 
SELECT * FROM (
  SELECT user_type, from_station_name,
         COUNT(*) AS rides,
         ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC) AS rnk
  FROM divvy_trips_2019.trips_summary
  WHERE from_station_name IS NOT NULL
  GROUP BY user_type, from_station_name
) r
WHERE rnk < 16;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--It gives the average ride length but for different quarters
SELECT user_type, quarter_label,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, quarter_label
ORDER BY quarter_label, user_type;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This code divides the users in the different age group 
SELECT user_type,
       CASE WHEN 2019 - birthyear < 25 THEN '<25'
            WHEN 2019 - birthyear < 35 THEN '25-34'
            WHEN 2019 - birthyear < 45 THEN '35-44'
            WHEN 2019 - birthyear < 55 THEN '45-54'
            ELSE '55+' END AS age_group,
       COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
WHERE birthyear BETWEEN 1939 AND 2003
GROUP BY user_type, age_group
ORDER BY user_type, age_group;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This code gives the total number of ride for each user type for the whole year
SELECT user_type, month_num, month_name, COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, month_num, month_name
ORDER BY user_type, month_num;

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--This code gives us the genders for each type of users
SELECT user_type, count(IF(gender="Male", 1, NULL)) as male, count(IF(gender="Female", 1, NULL)) AS female
FROM divvy_trips_2019.trips_summary
GROUP BY user_type;
```
<a href="https://github.com/rehaan454600-cmd/Cyclistic_bike_share_analysis.2019/tree/main/Summary%20Tables"> Tables which were created from the above SQL code.

### 5. Visualize:
Built the charts and dashboard in Tableau.

<img width="1920" height="1046" alt="Dashboard" src="https://github.com/user-attachments/assets/6b0a37f6-3c7c-4b01-9bee-3793ce701145" />

### 6. Present:
built a PowerPoint deck that walks through the objective, analysis, and recommendations for the Cyclistic executive team:
<a href="https://github.com/rehaan454600-cmd/Cyclistic_bike_share_analysis.2019/blob/main/Cyclistic%20users%2C%202019.pdf"> Cyclistic users, 2019

## Key findings
- Members take 77% of rides, but casual riders account for about 48% of total ride time.
- Casual rides are about 3 times longer on average (39.4 min vs. 12.9 min). 41% of casual rides last over 30 minutes, vs. about 6% for members.
- Members ride mostly on weekdays, with peaks around 8 AM and 5 PM (commuting). Casual riders peak on weekends, from noon to 5 PM.
- Casual riding is highly seasonal: 56% of casual rides happen from June to August.
- Casual riders start mostly from lakefront and tourist areas (such as Streeter Dr & Grand Ave and Millennium Park). Members start mostly from downtown business areas.
- Among riders with recorded data, casual riders skew younger (26% under 25, vs. 9% of members) and include a larger share of women (38% vs. 25%).

## Recommendations
1. Market Cyclistic as an everyday transportation option, highlighting commuting and errands to casual riders who mostly ride for leisure.
2. Focus campaigns and events on the spring and summer months and on the top 15 casual-ride start stations, without ignoring other seasons and stations.
3. Pilot events for riders under 35: some member-only (group rides, races, meetups) and some free for everyone, so casual riders can see what a membership offers. Track sign-ups after each event.

## Limitations
- The data counts rides, not riders. There are no rider IDs, so one person with many rides counts many times.
- Age is recorded for only about 40% of casual rides, and gender for about 39%, so those findings describe a partial sample.
- The data is from 2019 and has no pricing, bike type, or trip purpose information.




