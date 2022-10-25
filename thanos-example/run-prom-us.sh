#!/bin/sh

prometheus \
  --config.file=prometheus-us.yml \
  --web.enable-lifecycle \
  --storage.tsdb.max-block-duration=10m \
  --storage.tsdb.min-block-duration=10m \
  --storage.tsdb.path=./data/prometheus-us \
  --web.listen-address=0.0.0.0:19090
