reload: reload-prom reload-am

reload-prom:
	curl -X POST http://127.0.0.1:9090/-/reload

reload-am:
	curl -X POST http://127.0.0.1:9093/-/reload

cleanup:
	rm -rf data
