FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# системные зависимости для psycopg2-binary/psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential libpq-dev curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# зависимости
COPY requirements.txt .
RUN python -m pip install -U pip && pip install --no-cache-dir -r requirements.txt

# приложение
COPY . .

# на всякий случай – явно укажем рабочую директорию
WORKDIR /app

# порт приложения
EXPOSE 8000

# команда по умолчанию (в Helm мы переопределяем на migrate+collectstatic+gunicorn)
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]
