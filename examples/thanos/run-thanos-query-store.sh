#!/bin/sh

thanos query \
  --http-address 0.0.0.0:9093 \
  --grpc-address 0.0.0.0:9094 \
  --store 127.0.0.1:19094 \
  --store 127.0.0.1:29094
