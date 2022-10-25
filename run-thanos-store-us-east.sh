#!/bin/sh

thanos store \
    --data-dir               /tmp/thanos-us-east \
    --objstore.config-file bucket_config_us-east.yaml \
    --http-address              0.0.0.0:59191 \
    --grpc-address              0.0.0.0:59090
