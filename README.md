# Cyclistic_bike_share_analysis.2019
**Cyclistic bike-share case study**: how casual riders and annual members use bikes differently. Analysis of 3.8M rides from 2019 with MySQL and Tableau, plus recommendations to convert casual riders into members.

## Data
- Divvy 2019 trip data, Q1 to Q4 (public data made available by Motivate International Inc.; the company name Cyclistic is fictional)
- 3,818,004 rides in total
- Raw files are not included in this report because of their size. Download them from the official Divvy trip data source. <a href="https://divvy-tripdata.s3.amazonaws.com/index.html"> Raw Dataset (Analysis uses the data from all the quarters of 2019)

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

### 2. Clean:
renamed `Subscriber` to `Member` and `Customer` to `Casual`, stored blank gender and birth year values as NULL, calculated ride length and weekday, and merged all `4 tables into one` for analysis.

### 3. Filter:
excluded 13 rides with negative duration and 1,849 rides longer than 24 hours (likely errors or unreturned bikes). 3,816,142 rides were used in the analysis.

### 4. Summarize:
wrote SQL queries for ride share, ride length, weekday, hour, month, quarter, station, age group, and gender.

### 5. Visualize:
built the charts and dashboard in Tableau.
