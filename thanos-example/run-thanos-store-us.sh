#!/bin/sh

thanos store \
  --data-dir ./data/thanos-cache-us \
  --objstore.config-file thanos-bucket-us.yml \
  --http-address 0.0.0.0:19193 \
  --grpc-address 0.0.0.0:19094
