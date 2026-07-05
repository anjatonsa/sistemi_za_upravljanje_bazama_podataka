import json
import os
import random
import time
import uuid
from datetime import datetime, timedelta, timezone

from kafka import KafkaProducer

KAFKA_BOOTSTRAP = os.environ.get("KAFKA_BOOTSTRAP", "kafka:9092")
TOPIC = os.environ.get("TOPIC", "sensor_events")
EVENTS_PER_SECOND = float(os.environ.get("EVENTS_PER_SECOND", "5"))

DEVICES = [
    {"device_id": "dev-001", "city": "Beograd"},
    {"device_id": "dev-002", "city": "Novi Sad"},
    {"device_id": "dev-003", "city": "Nis"},
    {"device_id": "dev-004", "city": "Kragujevac"},
    {"device_id": "dev-005", "city": "Leskovac"},
]


def build_event() -> dict:
    device = random.choice(DEVICES)
    event_time = datetime.now(timezone.utc)

    return {
        "event_id": str(uuid.uuid4()),
        "device_id": device["device_id"],
        "city": device["city"],
        "temperature": round(random.uniform(15.0, 35.0), 2),
        "humidity": round(random.uniform(30.0, 90.0), 2),
        "event_time": event_time.strftime("%Y-%m-%d %H:%M:%S.%f")[:-3],
    }


def main():
    print(f"Povezivanje na Kafka broker: {KAFKA_BOOTSTRAP}")
    producer = KafkaProducer(
        bootstrap_servers=KAFKA_BOOTSTRAP,
        value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        retries=10,
        retry_backoff_ms=2000,
    )

    interval = 1.0 / EVENTS_PER_SECOND
    print(f"Slanje događaja u topic '{TOPIC}' (~{EVENTS_PER_SECOND} dogadjaja/s)...")

    sent = 0
    while True:
        event = build_event()
        producer.send(TOPIC, value=event)
        sent += 1
        if sent % 25 == 0:
            print(f"[{sent}] poslato: {event}")
        time.sleep(interval)


if __name__ == "__main__":
    main()
