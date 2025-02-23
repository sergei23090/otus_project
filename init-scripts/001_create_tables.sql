CREATE DATABASE IF NOT EXISTS logs;

CREATE TABLE IF NOT EXISTS logs.analytic_events_security
(
    `DateTime_vector` DateTime,
    `event_timestamp` DateTime,
    `server` String,
    `application` String,
    `pid` String,
    `log_level` String,
    `event_type` String,
    `user` String,
    `source_ip` String,  
    `destination_ip` String, 
    `details` String,
    `status` String,
    `error_code` String,    
    `raw_string` String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/logs/analytic_events_security', '{replica}')
PARTITION BY toYYYYMM(DateTime_vector)
ORDER BY (DateTime_vector, server, application, user)
SETTINGS index_granularity = 8192;

CREATE TABLE IF NOT EXISTS logs.analytic_events_security_buffer 
AS logs.analytic_events_security
ENGINE = Buffer(
    logs, 
    analytic_events_security, 
    16, -- Количество потоков
    10, -- Максимальное время в секундах
    100, -- Максимальное количество строк
    1048576, -- Максимальный размер данных в байтах
    10485760, -- Максимальный объем данных в памяти
    1000000, -- Максимальное количество строк в памяти
    10000000 -- Максимальный объем данных в памяти
);

CREATE TABLE IF NOT EXISTS logs.analytic_events_security_dist
AS logs.analytic_events_security
ENGINE = Distributed(
    otus, -- Имя кластера из конфигурации remote_servers
    logs, 
    analytic_events_security, 
    rand() -- Функция для распределения данных между шардами
);

CREATE TABLE IF NOT EXISTS logs.docker_logs
(
    DateTime_vector DateTime,
    container_created_at String,
    container_id String,
    container_name String,
    host String,
    image String,
    message String,
    source_type String,
    stream String,
    timestamp String,
    label String
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/replicated_logs', '{replica}')
ORDER BY (container_name, toStartOfMinute(DateTime_vector))
PARTITION BY toYYYYMM(DateTime_vector);

CREATE TABLE IF NOT EXISTS logs.docker_logs_buffer 
AS logs.docker_logs
ENGINE = Buffer(
    logs, 
    docker_logs, 
    16, -- Количество потоков
    10, -- Максимальное время в секундах
    100, -- Максимальное количество строк
    1048576, -- Максимальный размер данных в байтах
    10485760, -- Максимальный объем данных в памяти
    1000000, -- Максимальное количество строк в памяти
    10000000 -- Максимальный объем данных в памяти
);

CREATE TABLE IF NOT EXISTS logs.docker_logs_dist
AS logs.docker_logs
ENGINE = Distributed(
    otus, -- Имя кластера из конфигурации remote_servers
    logs, 
    docker_logs, 
    rand() -- Функция для распределения данных между шардами
);





