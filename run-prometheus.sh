#!/bin/sh

CONFIG_FILE=${1?Prometheus config file required (as first parameter of ./run-prometheus.yml}

prometheus --config.file=$CONFIG_FILE --web.enable-lifecycle
