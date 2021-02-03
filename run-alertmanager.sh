#!/bin/sh

CONFIG_FILE=${1?Alert Manager config file required (as first parameter of ./run-alertmanager.sh}

alertmanager --config.file=$CONFIG_FILE
