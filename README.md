[Ondrej Sika (sika.io)](https://which.sika.io) | <ondrej@sika.io> | [course ->](#course) | [install ->](#install-prometheus-locally)

![](images/prometheus_github.svg)

# Prometheus Training

    Ondrej Sika <ondrej@ondrejsika.com>
    https://github.com/ondrejsika/prometheus-training

Source of my Prometheus Training

## About Course

- [Proetheus Training in Czech Republic](https://ondrej-sika.cz/skoleni/prometheus?_s=gh-prometheus-training)
- [Proetheus Training in Europe & Middle East](https://ondrej-sika.com/training/prometheus?_s=gh-prometheus-training)

### Related Courses

- Kubernetes Training - [ondrejsika/kubernetes-training](https://github.com/ondrejsika/kubernetes-training) (on Github)


### Slides

<https://sika.link/prom-slides> TODO


### Any Questions?

Write me mail to <ondrej@sika.io>

<!-- BEGIN Install -->

## Install Prometheus Locally

### Mac

```
brew install prometheus
```

<!-- END Install -->

## Course

## What is Prometheus

### Prometheus vs Others

TODO

More at https://prometheus.io/docs/introduction/comparison/


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


## Thank you & Questions

### Ondrej Sika

- email:	<ondrej@sika.io>
- web:	[sika.io](https://which.sika.io)
- twitter: 	[@ondrejsika](https://twitter.com/ondrejsika)
- linkedin:	[/in/ondrejsika/](https://linkedin.com/in/ondrejsika/)

_Do you like the course? Write me recommendation on Twitter (with handle `@ondrejsika`) and LinkedIn. Thanks._


## Resources

- Prometheus vs Others - https://prometheus.io/docs/introduction/comparison/
