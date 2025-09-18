# Geospatial Data Science on NYC Bike Trip Data (PostgreSQL + PostGIS + GeoPandas)

A **PostgreSQL/PostGIS–first** project that ingests NYC bike-trip data, answers core business questions, bins usage by time, prepares spatial data (SRIDs, point geometry creation), performs tract-level spatial joins/aggregations, and runs proximity/buffer analysis for operations. Further, **GeoPandas** and **Folium** are used to visualize the aggregated data in Python.

---

## 📂 Repository Contents

- `01_ddl.sql` — Enable PostGIS, create base tables (`stations`, `trip_data`), load notes for tracts.  
- `02_query.sql` — Business queries (counts, % e-bikes, busiest stations, average duration).  
- `03_time_based_analysis.sql` — Half-hour time bucketing + busiest intervals.  
- `04_spatial_data_analysis.sql` — CRS/SRID prep, station points, spatial joins, tract aggregation, buffers.

```
├── analysis_exports/
│   ├── half_hour_interval_start_counts.csv
│   ├── spatio_temporal_visualization_05_01_202509171746.csv
│   ├── top_stations_buffer.csv
│   └── trip_count_by_census_tract.csv
├── data/
│   ├── nyct2020.geojson
│   ├── stations.csv
│   └── trip_data.csv
├── scripts/
│   ├── 01_ddl.sql                         #Enable PostGIS, create base tables (`stations`, `trip_data`), load notes for tracts. 
│   ├── 02_query.sql                       #Business queries (counts, % e-bikes, busiest stations, average duration).
│   ├── 03_time_based_analysis.sql         #Half-hour time bucketing + busiest intervals. 
│   └── 04_spatial_data_analysis.sql       #CRS/SRID prep, station points, spatial joins, tract aggregation, buffers.
├── README.md
├── notebook.ipynb
└── nyc_trip_choropleth.html
```


> Execute scripts **in order** (see “Run the project” below).

---

## ⚙️ Tech stack

- **PostgreSQL**  
- **PostGIS** extension installed (`CREATE EXTENSION postgis;`)  
- **GDAL/ogr2ogr** for quick loading of GeoJSON → PostGIS
- **QGIS** for visualizations
- **GeoPandas** to perform analysis and visualization with Python
- **Folium** for interactive map creation.

---

## 🚀 Run the Project

From `psql` (or your SQL client), run the scripts in order:

```sql
\i 01_ddl.sql
\i 02_query.sql
\i 03_time_based_analysis.sql
\i 04_spatial_data_analysis.sql
