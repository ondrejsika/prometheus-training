#!/bin/sh

PROMETHEUS_URL=${PROMETHEUS_URL:-http://127.0.0.1:9090}

curl -sG $PROMETHEUS_URL/api/v1/query_range \
  -d 'query=example_minute' \
  -d 'start=2025-06-04T09:00:00Z' \
  -d 'end=2025-06-04T09:05:00Z' \
  -d 'step=60' | jq
