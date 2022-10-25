#!/bin/sh

thanos sidecar \
    --tsdb.path            /tmp/prometheus-us-east \
    --prometheus.url       "http://localhost:29090" \
    --objstore.config-file bucket_config_us-east.yaml \
    --http-address              0.0.0.0:39191 \
    --grpc-address              0.0.0.0:39090
