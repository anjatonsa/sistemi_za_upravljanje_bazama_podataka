CREATE TABLE events_local ON CLUSTER 'analytics_cluster'
(
    event_date  Date,
    user_id     UInt64,
    event_type  String,
    message     String
)
ENGINE = ReplicatedMergeTree(
    '/clickhouse/{cluster}/tables/{shard}/events',
    '{replica}'
)
PARTITION BY toYYYYMM(event_date)
ORDER BY (user_id, event_date);

CREATE TABLE events ON CLUSTER 'analytics_cluster'
AS events_local
ENGINE = Distributed('analytics_cluster', default, events_local, rand());


SELECT replica_name, is_leader, is_readonly, queue_size, absolute_delay
FROM system.replicas
WHERE table = 'events_local';


INSERT INTO events_local VALUES
    (today(), 1001, 'login',   'User logged in'),
    (today(), 1002, 'purchase','Item purchased'),
    (today(), 1003, 'logout',  'User logged out');


INSERT INTO events_local VALUES
    (today(), 1004, 'login',   'User logged in')


INSERT INTO events_local
SELECT
    today(),
    number + 2000,
    'batch_insert',
    concat('batch_insert_message ', toString(number))
FROM numbers(10000);


SET insert_quorum = 2;
SET insert_quorum_timeout = 60000;



