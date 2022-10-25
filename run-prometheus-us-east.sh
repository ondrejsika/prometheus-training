#!/bin/sh

prometheus --config.file=prometheus-us-east.yml --web.enable-lifecycle  --storage.tsdb.max-block-duration=10m  --storage.tsdb.min-block-duration=10m --storage.tsdb.path=/tmp/prometheus-us-east --web.listen-address=0.0.0.0:29090
