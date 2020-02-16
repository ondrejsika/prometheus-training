[Ondrej Sika (sika.io)](https://which.sika.io) | <ondrej@sika.io> | [course ->](#course) | [install ->](#install-prometheus-locally)

![](images/prometheus_github.svg)

# Prometheus Training

    Ondrej Sika <ondrej@ondrejsika.com>
    https://github.com/ondrejsika/prometheus-training

Source of my Prometheus Training

## About Course

- [Proetheus Training in Czech Republic](https://ondrej-sika.cz/skoleni/prometheus?_s=gh-prometheus-training)
- [Proetheus Training in Europe & Middle East](https://ondrej-sika.com/training/prometheus?_s=gh-prometheus-training)


### Any Questions?

Write me mail to <ondrej@sika.io>


### Related Courses

- Kubernetes Training - [ondrejsika/kubernetes-training](https://github.com/ondrejsika/kubernetes-training) (on Github)

## About Me - Ondrej Sika

**DevOps Engineer, Consultant & Lecturer**

Git, Gitlab, Gitlab CI, Docker, Kubernetes, Terraform, Prometheus, ELK / EFK

## Star, Create Issues, Fork, and Contribute

Feel free to star this repository or fork it.

If you found bug, create issue or pull request.

Also feel free to propose improvements by creating issues.

## Live Chat

For sharing links & "secrets".

<https://tlk.io/sika-prometheus>

<!-- BEGIN Install -->

## Install Prometheus Locally

### Mac

```
brew install prometheus
```

<!-- END Install -->

## Course

## Agenda

- Prometheus
  - Intro
  - Install Prometheus
  - Basic configuration
  - Scraping & Exporters
  - Push Gateway
  - PromQL
  - Alerting
- Alert Manager
  - Install Alert Manager
  - Routes
  - Receivers
- Grafana
  - Instal Grafana
  - Working with dashboards
  - Prometheus integration


## What is Prometheus?

Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012, many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. It is now a standalone open source project and maintained independently of any company. To emphasize this, and to clarify the project's governance structure, Prometheus joined the Cloud Native Computing Foundation in 2016 as the second hosted project, after Kubernetes. -- [Prometheus website](https://prometheus.io/docs/introduction/overview/#what-is-prometheus)

### Prometheus Features

- time series DB
- PromQL - a flexible query language
- metrics scraping
- support for push metrics (Push Gateway)
- service discovery & static config
- many exporters
- alert manager

### Prometheus Architecture

![Prometheus Architecture](images/prometheus-architecture.png)

### Metric Types

- Counter
- Gauge
- Histogram
- Summary

#### Counter

A counter is a cumulative metric that represents a single monotonically increasing counter whose value can only increase or be reset to zero on restart. For example, you can use a counter to represent the number of requests served, tasks completed, or errors.

#### Gauge

A gauge is a metric that represents a single numerical value that can arbitrarily go up and down.

Gauges are typically used for measured values like temperatures or current memory usage, but also "counts" that can go up and down, like the number of concurrent requests.

#### Histogram

A histogram samples observations (usually things like request durations or response sizes) and counts them in configurable buckets. It also provides a sum of all observed values.

A histogram with a base metric name of `<basename>` exposes multiple time series during a scrape:

- cumulative counters for the observation buckets, exposed as `<basename>_bucket{le="<upper inclusive bound>"}`
- the total sum of all observed values, exposed as `<basename>_sum`
- the count of events that have been observed, exposed as `<basename>_count (identical to <basename>_bucket{le="+Inf"}` above)


## Run Prometheus

### Test Prometheus with Simple Config

Run

```
prometheus --config.file=01_prometheus.yml
```

See <http://127.0.0.1:9090>

![](images/prometheus-default-view.png)

### Run Random Metrics Generator

Run in Docker (see [source](docker/random-metrics))

```
docker run --name random8080 -d -p 8080:8080 ondrejsika/random-metrics
docker run --name random8081 -d -p 8081:8080 ondrejsika/random-metrics
docker run --name random8082 -d -p 8082:8080 ondrejsika/random-metrics
```

Run Prometheus with those sample targets

```
prometheus --config.file=02_prometheus.yml
```

See <http://127.0.0.1:9090>

### Simple Queries

```
rpc_durations_seconds_count
```

See <http://localhost:9090/graph?g0.range_input=1h&g0.expr=rpc_durations_seconds_count&g0.tab=0>

```
rate(rpc_durations_seconds_count[5m])
```

See <http://localhost:9090/graph?g0.range_input=1h&g0.expr=rate(rpc_durations_seconds_count%5B5m%5D)&g0.tab=0>

```
avg(rate(rpc_durations_seconds_count[5m]))
```

See <http://localhost:9090/graph?g0.range_input=1h&g0.expr=avg(rate(rpc_durations_seconds_count%5B5m%5D))&g0.tab=0>

```
avg(rate(rpc_durations_seconds_count[5m])) by (job, service)
```

See <http://localhost:9090/graph?g0.range_input=1h&g0.expr=avg(rate(rpc_durations_seconds_count%5B5m%5D))%20by%20(job%2C%20service)&g0.tab=0>

## Prometeheus Exporters

### What are Prometeheus Exporters?

There are a number of libraries and servers which help in exporting existing metrics from third-party systems as Prometheus metrics. This is useful for cases where it is not feasible to instrument a given system with Prometheus metrics directly (for example, HAProxy or Linux system stats).

#### Popular exporters:

- Node Exporter (official) - <https://github.com/prometheus/node_exporter>
- Blackbox Exporter (official) - <https://github.com/prometheus/blackbox_exporter>
- cAdvisor (Docker) - <https://github.com/google/cadvisor>
- Kube State Metrics - <https://github.com/kubernetes/kube-state-metrics>
- MySQL Exporter (official) - <https://github.com/prometheus/mysqld_exporter>
- Postgres Exporter - <https://github.com/wrouesnel/postgres_exporter>

All exporters are on Prometheus website: <https://prometheus.io/docs/instrumenting/exporters/>
Defult ports of exporters: <https://github.com/prometheus/prometheus/wiki/Default-port-allocations>

### Node Exporter

[source](https://github.com/prometheus/node_exporter)

Install on host using Docker:

```
docker run --name node-exporter -d --net=host --pid=host -v /:/host:ro,rslave quay.io/prometheus/node-exporter --path.rootfs=/host
```

See: <http://example.sikademo.com:9100/metrics>

### Blackbox Exporter

[source](https://github.com/prometheus/blackbox_exporter)

Install on host using Docker:

```
docker run --rm -d -p 9115:9115 --name blackbox_exporter prom/blackbox-exporter:master
```

See: <http://example.sikademo.com:9115/metrics>

Check status code 200 on website:

- sika.io: <http://http://example.sikademo.com:9115/probe?module=http_2xx&target=https://sika.io>
- foo.int (not working): <http://http://example.sikademo.com:9115/probe?module=http_2xx&target=https://foo.int>


### cAdvisor

[source](https://github.com/google/cadvisor)

Install on host using Docker:

```
docker run --volume=/:/rootfs:ro --volume=/var/run:/var/run:ro --volume=/sys:/sys:ro --volume=/var/lib/docker/:/var/lib/docker:ro --volume=/dev/disk/:/dev/disk:ro --publish=9338:9338 --detach=true --name=cadvisor gcr.io/google-containers/cadvisor:latest --port=9338
```

See:

- Metrics: <http://example.sikademo.com:9338/metrics>
- Dashboar: <http://example.sikademo.com:9338/>


## Thank you! & Questions?

That's it. Do you have any questions? **Let's go for a beer!**

### Ondrej Sika

- email: <ondrej@sika.io>
- web: <https://sika.io>
- twitter: [@ondrejsika](https://twitter.com/ondrejsika)
- linkedin:	[/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)
- Newsletter, Slack, Facebook & Linkedin Groups: <https://join.sika.io>

_Do you like the course? Write me recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn (add me [/in/ondrejsika](https://www.linkedin.com/in/ondrejsika/) and I'll send you request for recommendation). __Thanks__._

Wanna to go for a beer or do some work together? Just [book me](https://book-me.sika.io) :)

## Resources

- Prometheus vs Others - https://prometheus.io/docs/introduction/comparison/
