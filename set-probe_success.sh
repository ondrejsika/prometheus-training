#!/bin/sh

cat <<EOF | curl --data-binary @- http://prom.sikademo.com:9091/metrics/job/demo/instance/demo/app/$1
# TYPE probe_success gauge
# HELP probe_success Service is up and running
probe_success $2
EOF
