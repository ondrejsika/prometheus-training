FROM golang:1.24 AS build
WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY main.go .
RUN CGO_ENABLED=0 go build

FROM scratch
COPY --from=build /build/example_time_exporter /usr/local/bin/example_time_exporter
CMD ["/usr/local/bin/example_time_exporter"]
EXPOSE 8000
