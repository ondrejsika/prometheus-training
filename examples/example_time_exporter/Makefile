IMAGE = ttl.sh/example-time-exporter-go

all: build push

build:
	docker build --platform linux/amd64 -t ${IMAGE} .

push:
	docker push ${IMAGE}

run :
	docker run -p 8000:8000 ${IMAGE}
