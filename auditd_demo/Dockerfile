FROM ubuntu:20.04

# Обновляем систему и устанавливаем auditd
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y auditd && \
    apt-get clean

# Копируем скрипт для запуска auditd
COPY run_auditd.sh /usr/local/bin/run_auditd.sh
RUN chmod +x /usr/local/bin/run_auditd.sh

# Запуск скрипта
CMD ["/usr/local/bin/run_auditd.sh"]
