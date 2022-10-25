#!/bin/sh

thanos query \
  --http-address 0.0.0.0:9090 \
  --grpc-address 0.0.0.0:9091 \
  --store 127.0.0.1:19092 \
  --store 127.0.0.1:29092
