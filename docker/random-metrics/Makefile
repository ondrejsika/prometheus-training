all: build push

build:
	docker build -t ondrejsika/random-metrics .

push:
	docker push ondrejsika/random-metrics

run:
	docker run --name random8080 -d -p 8080:8080 ondrejsika/random-metrics
	docker run --name random8081 -d -p 8081:8080 ondrejsika/random-metrics
	docker run --name random8082 -d -p 8082:8080 ondrejsika/random-metrics

stop:
	docker rm -f random8080 random8081 random8082
