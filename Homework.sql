

-- Question 1

CREATE MATERIALIZED VIEW zn_avg_min_max AS

WITH zone_avg_min_max as (
    SELECT 
        pulocationid
        ,dolocationid
        ,MIN(tpep_dropoff_datetime - tpep_pickup_datetime) as min
        ,MAX(tpep_dropoff_datetime - tpep_pickup_datetime) as max
        ,AVG(tpep_dropoff_datetime - tpep_pickup_datetime) as avg

    FROM 
        trip_data
    
    GROUP BY
        pulocationid
        ,dolocationid
)

SELECT
    B.zone AS pickup_zone
    ,C.zone AS dropoff_zone
    ,min AS min_trip_time
    ,max AS max_trip_time
    ,avg AS avg_trip_time

FROM zone_avg_min_max A
    JOIN taxi_zone B
        ON A.pulocationid = B.location_id
    JOIN taxi_zone C
        ON A.dolocationid = C.location_id

ORDER BY
    avg DESC


-- Question 1 Answer: Yorkville East, Steinway

-- Question 2
CREATE MATERIALIZED VIEW zn_avg_min_max_count AS
WITH zone_avg_min_max as (
    SELECT 
        pulocationid
        ,dolocationid
        ,MIN(tpep_dropoff_datetime - tpep_pickup_datetime) as min
        ,MAX(tpep_dropoff_datetime - tpep_pickup_datetime) as max
        ,AVG(tpep_dropoff_datetime - tpep_pickup_datetime) as avg
        ,count(1) as num_trips

    FROM 
        trip_data
    
    GROUP BY
        pulocationid
        ,dolocationid
)

SELECT
    B.zone AS pickup_zone
    ,C.zone AS dropoff_zone
    ,min AS min_trip_time
    ,max AS max_trip_time
    ,avg AS avg_trip_time
    ,num_trips

FROM zone_avg_min_max A
    JOIN taxi_zone B
        ON A.pulocationid = B.location_id
    JOIN taxi_zone C
        ON A.dolocationid = C.location_id

ORDER BY
    avg DESC

-- Question 2 Answer: 1


-- Question 3

CREATE MATERIALIZED VIEW top_3_busiest_zones AS
WITH latest_pickup as (
    SELECT max(tpep_pickup_datetime) as latest_pickup_datetime
    FROM trip_data
)

SELECT
    B.zone AS pickup_zone
    ,count(1) as num_pickups

FROM
    trip_data A 
    JOIN taxi_zone B
        ON A.pulocationid = B.location_id
WHERE
    A.tpep_pickup_datetime < (SELECT * FROM latest_pickup) and A.tpep_dropoff_datetime > ((SELECT * FROM latest_pickup) - interval '17 hours')

GROUP BY
    B.zone

ORDER BY num_pickups DESC

LIMIT 3


-- Question 3 Answer: JFK Airport, LaGuardia Airport, Penn Station/Madison Sq West
