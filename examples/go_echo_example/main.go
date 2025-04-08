package main

import (
	"errors"
	"log"
	"net/http"
	"os"

	"github.com/labstack/echo-contrib/echoprometheus"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/rs/zerolog"
)

func main() {
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true
	logger := zerolog.New(os.Stdout)
	e.Use(middleware.RequestLoggerWithConfig(middleware.RequestLoggerConfig{
		LogURI:    true,
		LogStatus: true,
		LogValuesFunc: func(c echo.Context, v middleware.RequestLoggerValues) error {
			logger.Debug().Str("type", "req").Str("path", v.URI).Int("status", v.Status).Msgf("Request %d %s", v.Status, v.URI)
			return nil
		},
	}))
	e.Use(echoprometheus.NewMiddleware("example"))
	e.GET("/metrics", echoprometheus.NewHandler())

	e.GET("/", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"message": "Hello from Echo!",
		})
	})

	e.GET("/hello", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello World!")
	})

	e.GET("/ahoj", func(c echo.Context) error {
		return c.String(http.StatusOK, "Ahoj Svete!")
	})

	e.GET("/error", func(c echo.Context) error {
		return c.String(http.StatusInternalServerError, "Internal Server Error")
	})

	logger.Info().Str("type", "startup").Msg("Listening on 0.0.0.0:8000, see http://127.0.0.1:8000 or http://127.0.0.1:8000/metrics")
	if err := e.Start(":8000"); err != nil && !errors.Is(err, http.ErrServerClosed) {
		log.Fatal(err)
	}
}
