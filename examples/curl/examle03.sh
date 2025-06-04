#!/bin/sh

PROMETHEUS_URL=${PROMETHEUS_URL:-http://127.0.0.1:9090}

curl -sG $PROMETHEUS_URL/api/v1/query \
  -d 'query=example_minute' \
  -d 'time=2025-06-04T09:00:10Z' | jq

curl -sG $PROMETHEUS_URL/api/v1/query \
  -d 'query=example_minute' \
  -d 'time=2025-06-04T09:53:10Z' | jq
