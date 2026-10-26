run:
	make -j app requests prom1 prom2 prom3

app:
	slu example-server

requests:
	slu w -- curl -fsSL http://127.0.0.1:8000

prom1:
	prometheus --config.file=prom1.yml --storage.tsdb.path=./data/prom1 --web.listen-address=127.0.0.1:9091

prom2:
	prometheus --config.file=prom2.yml --storage.tsdb.path=./data/prom2 --web.listen-address=127.0.0.1:9092

prom3:
	prometheus --config.file=prom3.yml --storage.tsdb.path=./data/prom3 --web.listen-address=127.0.0.1:9093 --web.enable-remote-write-receiver

check:
	promtool check config prom1.yml prom2.yml prom3.yml

clean:
	rm -rf ./data
