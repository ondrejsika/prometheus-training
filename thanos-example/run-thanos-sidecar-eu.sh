#!/bin/sh

thanos sidecar \
  --tsdb.path ./data/prometheus-eu \
  --prometheus.url http://127.0.0.1:29090 \
  --objstore.config-file thanos-bucket-eu.yml \
  --http-address 0.0.0.0:29191 \
  --grpc-address 0.0.0.0:29092
