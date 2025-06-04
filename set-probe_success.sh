#!/bin/sh

PUSH_PROXY_URL=${PUSH_PROXY_URL:-http://prom.sikademo.com:9091}

cat <<EOF | curl --data-binary @- $PUSH_PROXY_URL/metrics/job/demo/instance/demo/app/$1
# TYPE probe_success gauge
# HELP probe_success Service is up and running
probe_success $2
EOF
