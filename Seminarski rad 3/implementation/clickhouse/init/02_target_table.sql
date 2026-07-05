CREATE TABLE IF NOT EXISTS iot.sensor_events
(
    event_id        String,
    device_id       String,
    city            String,
    temperature     Float32,
    humidity        Float32,
    event_time      DateTime64(3),
    processing_time DateTime64(3) DEFAULT now64(3),
    ingest_date     Date DEFAULT toDate(processing_time)
)
ENGINE = MergeTree()
PARTITION BY ingest_date
ORDER BY (device_id, event_time);

