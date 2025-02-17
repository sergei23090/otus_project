FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY event_generator.py .
# При запуске контейнера скрипт будет писать логи в /app/events.out
CMD ["python", "event_generator.py"]
