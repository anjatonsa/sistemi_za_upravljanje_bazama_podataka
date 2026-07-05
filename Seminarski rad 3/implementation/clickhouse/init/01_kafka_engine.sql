CREATE DATABASE IF NOT EXISTS iot;
CREATE TABLE IF NOT EXISTS iot.sensor_events_queue
(
    event_id    String,
    device_id   String,
    city        String,
    temperature Float32,
    humidity    Float32,
    event_time  DateTime64(3)
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'sensor_events',
    kafka_group_name = 'clickhouse_sensor_consumer',
    kafka_format = 'JSONEachRow',
    kafka_num_consumers = 1,
    kafka_skip_broken_messages = 10;
