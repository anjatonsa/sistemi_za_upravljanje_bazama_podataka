SELECT count() AS total_events FROM iot.sensor_events;


SELECT
    event_id,
    device_id,
    event_time,
    processing_time,
    dateDiff('millisecond', event_time, processing_time) AS latency_ms
FROM iot.sensor_events
ORDER BY latency_ms DESC
LIMIT 3;


SELECT
    city,
    round(avg(temperature), 2) AS avg_temperature,
    round(max(temperature), 2) AS max_temperature,
    round(min(temperature), 2) AS min_temperature,
    count() AS num_readings
FROM iot.sensor_events
WHERE ingest_date = today()
GROUP BY city
ORDER BY city;
