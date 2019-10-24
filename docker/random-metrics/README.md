Build

```
docker build -t ondrejsika/random-metrics .
```

Push

```
docker push ondrejsika/random-metrics
```

Run

```
docker run --name random8080 -d -p 8080:8080 ondrejsika/random-metrics
docker run --name random8081 -d -p 8081:8080 ondrejsika/random-metrics
docker run --name random8082 -d -p 8082:8080 ondrejsika/random-metrics
```
