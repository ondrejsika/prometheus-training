#!/bin/sh

thanos query \
    --http-address 0.0.0.0:19192 \
    --store        127.0.0.1:19090 \
    --store        127.0.0.1:59090
