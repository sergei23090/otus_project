import time
import json
import random
from datetime import datetime
from faker import Faker

fake = Faker()

# Списки для генерации данных
servers = ["server01", "server02", "server03", "server-db", "server-app", "gateway01", "fw01"]
applications = ["sshd", "firewall", "apache2", "nginx", "cron", "systemd", "postgres", "IDS", "VPN"]
log_levels = ["INFO", "WARNING", "ERROR", "CRITICAL"]
security_events = [
    "Failed password for invalid user",
    "User login succeeded",
    "Access denied for user",
    "Multiple failed login attempts detected",
    "Suspicious file access",
    "Port scan detected",
    "Intrusion attempt detected",
    "Malware signature detected",
    "Unauthorized access attempt",
    "System integrity check failed"
]

def generate_internal_ip():
    if random.choice([True, False]):
        return f"10.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(1,254)}"
    else:
        return f"192.168.{random.randint(0,255)}.{random.randint(1,254)}"

def generate_log():
    # Получаем текущее время в формате, подходящем для DateTime ClickHouse
    now_str = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
    event_timestamp = now_str  # Можно использовать текущее время в качестве event_timestamp
    server = random.choice(servers)
    app = random.choice(applications)
    pid = random.randint(100, 9999)
    log_level = random.choice(log_levels)
    event = random.choice(security_events)
    
    # Генерация дополнительных данных
    user = ""
    src_ip = ""
    dest_ip = ""
    if any(x in event for x in ["Failed", "Access denied", "Unauthorized", "Multiple failed"]):
        user = fake.user_name()
        src_ip = generate_internal_ip()
        dest_ip = generate_internal_ip()
        message = f"{event} for user {user} from {src_ip} to {dest_ip}"
    elif any(x in event.lower() for x in ["succeeded", "login"]):
        user = fake.user_name()
        src_ip = generate_internal_ip()
        message = f"{event} for user {user} from {src_ip}"
    elif any(x in event for x in ["Port scan", "Intrusion", "Malware"]):
        src_ip = generate_internal_ip()
        dest_ip = generate_internal_ip()
        message = f"{event} detected from {src_ip} targeting {dest_ip}"
    else:
        message = event

    # Для ERROR и CRITICAL задаём код ошибки
    error_code = random.choice([401, 403, 404, 500, 503]) if log_level in ["ERROR", "CRITICAL"] else None

    # Формирование словаря с полями, соответствующими таблице
    log_entry = {
        "event_timestamp": event_timestamp,
        "server": server,
        "application": app,
        "pid": pid,
        "log_level": log_level,
        "event_type": event,
        "user": user,
        "source_ip": src_ip,
        "destination_ip": dest_ip,
        "details": message,
        "status": "failure" if log_level in ["ERROR", "CRITICAL"] else "success",
        "error_code": error_code,
        "raw_string": message
    }
    return log_entry

log_file = "/app/events.out"

print("Starting JSON security log generator. Logs will be written to", log_file)
with open(log_file, "a") as f:
    while True:
        log_entry = generate_log()
        f.write(json.dumps(log_entry) + "\n")
        f.flush()
        print(log_entry)
        time.sleep(random.uniform(0.1, 1))
