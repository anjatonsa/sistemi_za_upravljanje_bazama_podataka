CREATE MATERIALIZED VIEW IF NOT EXISTS iot.sensor_events_mv
TO iot.sensor_events
AS
SELECT
    event_id,
    device_id,
    city,
    temperature,
    humidity,
    event_time
FROM iot.sensor_events_queue;

