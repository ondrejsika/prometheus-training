package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

// Define a metric
var requestCounter = prometheus.NewCounterVec(
	prometheus.CounterOpts{
		Name: "http_requests_total",
		Help: "Total number of HTTP requests",
	},
	[]string{"path"},
)

func main() {
	// Register metrics
	prometheus.MustRegister(requestCounter)

	// Simple handler that increments counter
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		requestCounter.WithLabelValues(r.URL.Path).Inc()
		fmt.Fprintf(w, "Hello, Prometheus!")
	})

	http.HandleFunc("/favicon.ico", func(w http.ResponseWriter, r *http.Request) {
		// 404 Not Found for favicon.ico
		http.NotFound(w, r)
	})

	// Metrics endpoint
	http.Handle("/metrics", promhttp.Handler())

	// Start HTTP server
	port := "8000"
	if os.Getenv("PORT") != "" {
		port = os.Getenv("PORT")
	}

	fmt.Println("Starting server on 0.0.0.0:" + port + ", see  http://127.0.0.1:" + port + " or http://127.0.0.1:" + port + "/metrics")
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
