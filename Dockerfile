FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Ставим базовые тулзы для сборки некоторых зависимостей (если понадобятся)
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
    && rm -rf /var/lib/apt/lists/*

# Ставим зависимости
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir gunicorn psycopg2-binary

# Копируем код
COPY . .

# Запускаем gunicorn (порт 8000 должен совпадать с values.yaml)
CMD ["gunicorn","app.wsgi:application","--bind","0.0.0.0:8000"]
