select * from public.trip_data;

-- Goal: understand the bike usage throughout the day.
-- Task: determine the times when the most bike trips start, 
----     listing these times in descending order from the busiest to the least busy, 
----     along with the corresponding bike trip counts. 
-- Hint: GROUP_BY(), ORDER_BY()

select 
	half_hour_starttime,
	COUNT(half_hour_starttime) as start_count
from public.trip_data
group by half_hour_starttime
order by start_count DESC;


-- Spatial Operations in GeoSpatial Analysis

-- Goal: transform census tract boundary files with UTM 18N projection
-- hint 1: the projection we would like to use for our project is UTM zone 18N (EPSG: 32618)
-- hint 2: working with projection ST_Transform() and ST_SetSRID - https://postgis.net/documentation/tips/st-set-or-transform/

select * from public.nyct2020;

alter table public.nyct2020
alter column wkb_geometry type geometry(MultiPolygon, 32618)
using ST_Transform(ST_SetSRID(wkb_geometry,4326), 32618);


-- Creating geometric columns and defining projections

-- Goal: turn stations table into geospatial data format and set the correct projection
-- hint 1: the spatial reference id for WGS84 latitude and longitude is 4326
-- hint 2: the projection we would like to use for our project is UTM zone 18N (EPSG: 32618)
-- hint 3: working with projection ST_Transform() and ST_SetSRID - https://postgis.net/documentation/tips/st-set-or-transform/

-- Step 1: Add a new geometry column to the bike_stations table
alter table public.stations
add column geom geometry(point, 4326);

select * from public.stations;

-- Step 2: Populate the new geom column using lat and lon columns
update public.stations
set geom = ST_SetSRID(ST_MakePoint(station_lon, station_lat),4326);

-- Step 3: Transform the geometry to UTM Zone 18N projection (EPSG: 32618)
alter table public.stations 
alter column geom type geometry(point, 32618)
using ST_Transform(geom, 32618);

-- Exploring the spatial_ref_sys table added during PostGIS Installation
select * from public.spatial_ref_sys;

-- Check out the spatial_ref_sys added by PostGIS where SRID = 32618
select * from public.spatial_ref_sys
where srid = 32618;

-- find out what SRID is currently being used by nyct2020 table
-- select find_srid('schema','table','column'); 
select find_srid('public','nyct2020','wkb_geometry'); 


-- Analyzing Patterns with Spatial Joins

-- Objective: determine how many bike trips started in each census tract.

-- Step 1: assign each bike station to the appropriate census tract using a spatial join
select
	s.station_id ,
	n.ogc_fid, -- Unique identifier for each census tract
	s.geom
from public.stations  as s
join public.nyct2020  as n 
	on ST_Within(s.geom, n.wkb_geometry); --checks whether the geometry in station table is in nyct2020 geometry or not
	
-- Step 2: joining stations with trip data

	with station_census as(
		select
			s.station_id ,
			n.ogc_fid, -- Unique identifier for each census tract
			s.geom
		from public.stations  as s
		join public.nyct2020  as n 
			on ST_Within(s.geom, n.wkb_geometry)
	)
	select
		td.ride_id,
		td.half_hour_starttime,
		sc.ogc_fid,
		td.start_station_id	
	from public.trip_data as td
	join station_census as sc
		on td.start_station_id = sc.station_id;

-- Step 3: grouping and counting trips by census tract

	with station_census as(
		select
			s.station_id ,
			n.ogc_fid, -- Unique identifier for each census tract
			s.geom,
			n.wkb_geometry
		from public.stations  as s
		join public.nyct2020  as n 
			on ST_Within(s.geom, n.wkb_geometry)
	)
	select
		sc.ogc_fid,
		count(td.ride_id) as trip_count,
		sc.wkb_geometry
	from public.trip_data as td
	join station_census as sc
		on td.start_station_id = sc.station_id
	group by sc.ogc_fid, sc.wkb_geometry
	order by trip_count DESC;


-- Step 4: save as table for visualization
	
	create table ct_trip_count AS
		with station_census as(
			select
				s.station_id ,
				n.ogc_fid, -- Unique identifier for each census tract
				s.geom,
				n.wkb_geometry
			from public.stations  as s
			join public.nyct2020  as n 
				on ST_Within(s.geom, n.wkb_geometry)
		)
		select
			sc.ogc_fid,
			count(td.ride_id) as trip_count,
			sc.wkb_geometry
		from public.trip_data as td
		join station_census as sc
			on td.start_station_id = sc.station_id
		group by sc.ogc_fid, sc.wkb_geometry
		order by trip_count DESC;
	
	select * from public.ct_trip_count;

-- Identifying nearby stations with Buffer

---- business goal: optimize van routes for replenishing bike stations
-- task: create a buffer of 1 kilometers around the top 3 bike stations where most of the trips started from, 
---- and perform a spatial join to analyze which nearby stations fall within a 1 km radius for easy servicing
	
-- hint: use ST_Buffer() and ST_Intersects() functions from PostGIS
	
-- Step 1: Identify top 3 stations where most trips started from
	select
		start_station_id,
		COUNT(*) as total_trips
	from public.trip_data
	group by start_station_id
	order by total_trips DESC
	limit 5;
-- Step 2: Create buffers around top 3 stations
with top_stations AS(
						select 
							station_id,
							geom
						from public.stations
						where station_id in(select
												start_station_id
											from public.trip_data
											group by start_station_id
											order by count(*) DESC
											limit 5)
						)
select 
	station_id,
	ST_Buffer(geom, 1000) --creating buffer zone of 1 km radius
from top_stations;


-- Step 3: Perform spatial join to find nearby stations of top stations
with top_stations_buffer as (
							select 
								station_id,
								ST_Buffer(geom, 1000) as buffer_geom
							from public.stations
							where station_id in(select
													start_station_id
												from public.trip_data
												group by start_station_id
												order by count(*) DESC
												limit 5)
	
						)
select
	s.station_id as nearby_stations,
	tsb.station_id as top_stations
from public.stations as s
join top_stations_buffer as tsb
	on ST_Intersects(s.geom,tsb.buffer_geom)
order by top_stations;
