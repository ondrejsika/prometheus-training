package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

var (
	unixTime = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "example_unix_time",
		Help: "Current Unix timestamp",
	})
	hour = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "example_hour",
		Help: "Current hour in UTC",
	})
	minute = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "example_minute",
		Help: "Current minute in UTC",
	})
	second = prometheus.NewGauge(prometheus.GaugeOpts{
		Name: "example_second",
		Help: "Current second in UTC",
	})
)

func main() {
	prometheus.MustRegister(unixTime)
	prometheus.MustRegister(hour)
	prometheus.MustRegister(minute)
	prometheus.MustRegister(second)

	go func() {
		for {
			currentTime := time.Now().UTC()
			unixTime.Set(float64(currentTime.Unix()))
			hour.Set(float64(currentTime.Hour()))
			minute.Set(float64(currentTime.Minute()))
			second.Set(float64(currentTime.Second()))
			time.Sleep(1 * time.Second)
		}
	}()

	http.Handle("/metrics", promhttp.Handler())

	port := "8000"
	if os.Getenv("PORT") != "" {
		port = os.Getenv("PORT")
	}

	fmt.Println("Starting server on 0.0.0.0:" + port + ", see http://localhost:" + port + "/metrics")
	err := http.ListenAndServe(":"+port, nil)
	if err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
