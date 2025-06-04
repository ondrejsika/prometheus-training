import os
import time
from datetime import datetime, timezone
from prometheus_client import Gauge, start_http_server

VERSION = 'dev'

info = Gauge('example_info', 'Information about the time exporter', ['version', 'start_time', 'implementation'])
unix_timestamp = Gauge('example_unix_time', 'Current Unix timestamp')
hour = Gauge('example_hour', 'Current hour in UTC')
minute = Gauge('example_minute', 'Current minute in UTC')
second = Gauge('example_second', 'Current second in UTC')

info.labels(VERSION, datetime.fromtimestamp(time.time(), tz=timezone.utc).isoformat(), "python").set(1)
start_http_server(int(os.getenv('PORT', 8000)))
print(f"See http://127.0.1:{os.getenv('PORT', 8000)}/metrics for metrics")

while True:
    current_time = time.gmtime()
    unix_timestamp.set(int(time.time()))
    hour.set(current_time.tm_hour)
    minute.set(current_time.tm_min)
    second.set(current_time.tm_sec)

    time.sleep(1)
