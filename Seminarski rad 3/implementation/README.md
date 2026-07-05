# Praktična implementacija: Integracija sistema za strimovanje podataka i baze podataka(Apache Kafka i ClickHouse)

## Pokretanje

Iz root direktorijuma projekta:

```bash
docker compose up -d --build
```

Producer odmah počinje da šalje simulirane događaje u topic `sensor_events`
(podrazumevano ~5 događaja u sekundi). Logovi producer komponente mogu se pratiti sa:

```bash
docker compose logs -f producer
```

## Provera da podaci stižu u Kafku

Kafka UI u browseru: **http://localhost:8083** → Topics → `sensor_events` → Messages. 

## Pristupanje ClickHouse klijentu

```bash
docker exec -it clickhouse-baze-proj3 clickhouse-client
```


