-- Check for PostGIS Extension

select * from PG_AVAILABLE_EXTENSIONS;

-- create extension

create extension postgis;

-- create table structure for stations.csv
CREATE TABLE public.stations (
	station_id varchar(50) NULL,
	station_lat float4 NULL,
	station_lon float4 NULL,
	primary key (station_id)
);


-- create table structure for trip_data.csv
CREATE TABLE public.trip_data (
	ride_id varchar(50) NULL,
	bike_type varchar(50) NULL,
	start_time varchar(50) NULL,
	end_time varchar(50) NULL,
	start_station_id varchar(50) NULL,
	end_station_id varchar(50) null,
	primary key (ride_id)
);

-- insert data or import from csv (ignore indexing)
copy public.trip_data(ride_id, bike_type, start_time, end_time, start_station_id, end_station_id)
FROM PROGRAM 'tail -n +2 /Users/atishdhamala/geospatial-data-science-project/data/trip_data.csv | cut -d, -f2-'
WITH (FORMAT csv, DELIMITER ',');

-- To import the nyct2020.geojson data
-- In Terminal: brew install gdal
-- 				ogr2ogr -f "PostgreSQL" PG:"dbname=dbname user= user password= password" /path/nyct2020.geojosn -nln tablename -nlt GEOMETRY

