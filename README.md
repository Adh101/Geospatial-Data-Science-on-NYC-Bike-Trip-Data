# Geospatial Data Science on NYC Bike Trip Data (PostgreSQL + PostGIS)

A **PostgreSQL/PostGIS–first** project that ingests NYC bike-trip data, answers core business questions, bins usage by time, prepares spatial data (SRIDs, point geometry creation), performs tract-level spatial joins/aggregations, and runs proximity/buffer analysis for operations.

---

## 📂 Repository Contents

- `01_ddl.sql` — Enable PostGIS, create base tables (`stations`, `trip_data`), load notes for tracts.  
- `02_query.sql` — Business queries (counts, % e-bikes, busiest stations, average duration).  
- `03_time_based_analysis.sql` — Half-hour time bucketing + busiest intervals.  
- `04_spatial_data_analysis.sql` — CRS/SRID prep, station points, spatial joins, tract aggregation, buffers.

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
