-- Challenge: When is the bike usage highest throughout the day?
-- Task: creating a new column that categorizes the start_time into half hours intervals

-- Add new column 

alter table public.trip_data 
add column half_hour_starttime timestamp;

-- Update the new column with half hour intervals based on starttime

update public.trip_data
set half_hour_starttime =
	date_trunc('hour',start_time::timestamp) +
	interval '30 minutes' * floor(extract(minute from start_time::timestamp)/ 30);

select * from public.trip_data;