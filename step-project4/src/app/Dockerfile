FROM python:3.12-slim

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .

RUN pip install --no-cache-dir flask flask-sqlalchemy pymysql cryptography pytest pytest-cov pytest-mock


FROM python:3.12-slim AS test

COPY app/test_app.py .
COPY app/app.py .

# Run tests
RUN pytest test_app.py

FROM python:3.12-slim AS build

WORKDIR /app

#COPY app/app.py .

RUN useradd -m viktor && \
    chown -R viktor:viktor /app
USER viktor

EXPOSE 5000

CMD ["python", "app.py"]