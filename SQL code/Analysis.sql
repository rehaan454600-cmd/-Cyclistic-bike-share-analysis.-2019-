SELECT * FROM divvy_trips_2019.trips_summary;

### This code gives average_ride_min, total_ride_hours and the percentage of Casial and Members 
SELECT user_type,
       COUNT(*)                                    AS rides,
       ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 1) AS per_of_rides,
       ROUND(AVG(ride_length_min),1)              AS avg_ride_min,
       ROUND(SUM(ride_length_min) / 60, 0)         AS total_ride_hours
FROM divvy_trips_2019.trips_summary
GROUP BY user_type;


### This gives the average time for rides in weeksdays
SELECT user_type, weekday_num, weekday_name,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, weekday_num, weekday_name
ORDER BY user_type, weekday_num;

### This code is the same but for month
SELECT user_type, month_num, month_name,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, month_num, month_name
ORDER BY user_type, month_num;

### THis code returns the average value of ride length and number of rides in that houre 
SELECT user_type, start_hour,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, start_hour
ORDER BY user_type, start_hour;

### This is the same result from the last code but for heat map
SELECT user_type, weekday_num, weekday_name, start_hour, COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, weekday_num, weekday_name, start_hour
ORDER BY user_type, weekday_num, start_hour;

### This lines of code makes it easy to classify number of ride and there duration 
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

### It finds the top 15 start stations per user type 
SELECT * FROM (
  SELECT user_type, from_station_name,
         COUNT(*) AS rides,
         ROW_NUMBER() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC) AS rnk
  FROM divvy_trips_2019.trips_summary
  WHERE from_station_name IS NOT NULL
  GROUP BY user_type, from_station_name
) r
WHERE rnk < 16;

# It gives the average ride lenght but for different quarters
SELECT user_type, quarter_label,
       COUNT(*) AS rides,
       ROUND(AVG(ride_length_min), 1) AS avg_ride_min
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, quarter_label
ORDER BY quarter_label, user_type;

### This code divides the useres in the different age group 
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

### This code gives the total number of ride for each user type for the whole year
SELECT user_type, month_num, month_name, COUNT(*) AS rides
FROM divvy_trips_2019.trips_summary
GROUP BY user_type, month_num, month_name
ORDER BY user_type, month_num;

### This code gives us the genders for each type of users
SELECT user_type, count(IF(gender="Male", 1, NULL)) as male, count(IF(gender="Female", 1, NULL)) AS female
FROM divvy_trips_2019.trips_summary
GROUP BY user_type;



