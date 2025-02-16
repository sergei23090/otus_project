CREATE DATABASE IF NOT EXISTS logs;

-- Одна таблица для auditd
CREATE TABLE IF NOT EXISTS logs.auditd_all (
    event_time DateTime DEFAULT now(),
    raw_string String
    /* при необходимости можно добавлять поля, если будете парсить JSON и т.д. */
)
ENGINE = MergeTree()
ORDER BY (event_time);