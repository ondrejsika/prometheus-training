#!/bin/sh

thanos sidecar \
  --tsdb.path ./data/prometheus-us \
  --prometheus.url http://127.0.0.1:19090 \
  --objstore.config-file thanos-bucket-us.yml \
  --http-address 0.0.0.0:19191 \
  --grpc-address 0.0.0.0:19092
