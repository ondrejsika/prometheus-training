#!/bin/sh

PROMETHEUS_URL=${PROMETHEUS_URL:-http://127.0.0.1:9090}

curl -sG $PROMETHEUS_URL/api/v1/query -d 'query=example_minute' | jq
