#!/bin/sh

prometheus \
  --config.file=prometheus-eu.yml \
  --web.enable-lifecycle \
  --storage.tsdb.max-block-duration=1m \
  --storage.tsdb.min-block-duration=1m \
  --storage.tsdb.path=./data/prometheus-eu \
  --web.listen-address=0.0.0.0:29090
