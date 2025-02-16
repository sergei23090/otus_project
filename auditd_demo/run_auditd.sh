#!/usr/bin/env bash
# Запускаем auditd в фоновом режиме и генерируем тестовые события для демонстрации

echo "Starting auditd..."
/sbin/auditd -f &
sleep 2

echo "Generating test audit events..."
while true; do
  # Генерация тестового события в файл /var/log/audit/audit.log
  echo "type=SYSCALL msg=audit(12345.678:90): random demo event" >> /var/log/audit/audit.log
  sleep 5
done
