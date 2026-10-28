use divvy_trips_2019;

SELECT
  trip_id,
  start_time,
  end_time,
  sec_to_time(TIMESTAMPDIFF(SECOND, start_time, end_time)) AS ride_length
FROM q1_2019
LIMIT 10;

USE divvy_trips_2019;

CREATE TABLE trips_2019 AS
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