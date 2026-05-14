
SELECT
    trip_id,
    location,
    departure_timestamp,
	LEAD(location) OVER (
        PARTITION BY trip_id
        ORDER BY arrival_timestamp
    ) AS next_location,
	LEAD(arrival_timestamp) OVER (
        PARTITION BY trip_id
        ORDER BY arrival_timestamp
    ) AS next_arrival,
	LEAD(arrival_timestamp) OVER (
        PARTITION BY trip_id
        ORDER BY arrival_timestamp
    ) - departure_timestamp AS driving_time
    FROM trip_events;