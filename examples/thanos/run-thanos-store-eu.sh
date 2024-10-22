#!/bin/sh

thanos store \
  --data-dir ./data/thanos-cache-eu \
  --objstore.config-file thanos-bucket-eu.yml \
  --http-address 0.0.0.0:29193 \
  --grpc-address 0.0.0.0:29094
