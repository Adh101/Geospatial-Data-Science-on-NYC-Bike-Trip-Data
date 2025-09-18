--Use public.stations to answer the following questions.
select * from public.stations;
-- Question 1: How many stations does BigApple BikeShare company have? 

select
	count(distinct station_id)
from public.stations;

--Use public.trip_data to answer the following questions.
select * from public.trip_data;
-- Question 2: How many trips were taken on September 17th? 

select
	count(ride_id)
from public.trip_data
where start_time::date = date '2024-09-17';

-- Question 3: What percentage of bike trips used an e-bike?

select
	(count(case when bike_type = 'ebike' then 1 end) * 100 / count(*)) as ebike_pct
from public.trip_data;

-- Question 4: which bike station had the most starting trips on that day? 

select
	start_station_id,
	COUNT(ride_id) as trip_count
from public.trip_data
where start_time::date = '2024-09-17'
group by start_station_id
order by trip_count desc;

-- Question 5: What’s the average length of a bike trip?

select 
	avg((end_time::timestamp - start_time::timestamp)) as average_trip_duration
from public.trip_data;