#!/bin/sh

thanos query \
  --http-address 0.0.0.0:9090 \
  --endpoint 0.0.0.0:19194 \
  --endpoint 0.0.0.0:29194
