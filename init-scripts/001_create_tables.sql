CREATE DATABASE IF NOT EXISTS logs;

CREATE TABLE IF NOT EXISTS logs.analytic_events_security (
    DateTime_vector DateTime CODEC(Delta, ZSTD(1)),
    event_timestamp DateTime CODEC(Delta, ZSTD(1)),
    server LowCardinality(String),
    application LowCardinality(String),
    pid UInt16,
    log_level LowCardinality(String),
    event_type LowCardinality(String),
    user LowCardinality(String),
    source_ip IPv4,
    destination_ip IPv4,
    details String CODEC(ZSTD(1)),
    status LowCardinality(String),
    error_code Nullable(UInt16),
    raw_string String CODEC(ZSTD(1))
)
ENGINE = MergeTree()
PARTITION BY toYYYYMM(DateTime_vector)
ORDER BY (DateTime_vector, server, application, user)
SETTINGS index_granularity = 8192;
