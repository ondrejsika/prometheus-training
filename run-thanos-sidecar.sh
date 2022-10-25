#!/bin/sh

thanos sidecar \
    --tsdb.path            data \
    --prometheus.url       "http://localhost:9090" \
    --objstore.config-file bucket_config.yaml \
    --http-address              0.0.0.0:19191 \
    --grpc-address              0.0.0.0:19090
