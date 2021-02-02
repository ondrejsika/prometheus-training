FROM golang as build
WORKDIR /build
RUN git clone https://github.com/prometheus/client_golang.git && \
  cd client_golang/examples/random && \
  go get -d && \
  go build

FROM debian
COPY --from=build /build/client_golang/examples/random /
CMD ["/random", "-listen-address=:80"]
EXPOSE 8080
