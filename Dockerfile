# Stage 1: Builder
FROM python:3.12.4-alpine as builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apk update && \
    apk upgrade && \
    apk add --no-cache gcc musl-dev libc-dev libpq-dev expat-dev openssl-dev

WORKDIR /undergraduate-study-program-etl

COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

# Stage 2: Runtime
FROM python:3.12.4-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN apk update && \
    apk upgrade && \
    apk add --no-cache libpq expat openssl

RUN addgroup -S app_group && adduser -S app_user -G app_group

USER app_user
WORKDIR /undergraduate-study-program-etl

COPY --from=builder /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

COPY ./src ./src

ENV PYTHONPATH=/undergraduate-study-program-etl

CMD ["python", "src/main.py"]
