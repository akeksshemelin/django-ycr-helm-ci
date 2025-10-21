FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Системные зависимости для сборки/рантайма psycopg2 и др.
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      libpq5 \
      python3-dev \
      pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Обновим pip и поставим зависимости проекта
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir gunicorn

# Кладём код
COPY . .

# Приложение слушает 8000 (совпадает с values.yaml)
CMD ["gunicorn","app.wsgi:application","--bind","0.0.0.0:8000"]
