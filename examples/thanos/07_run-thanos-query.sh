#!/bin/sh

thanos query \
  --http-address 0.0.0.0:9090 \
  --endpoint 127.0.0.1:19192 \
  --endpoint 127.0.0.1:29192 \
  --endpoint 127.0.0.1:19194 \
  --endpoint 127.0.0.1:29194
