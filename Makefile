fmt:
	yarn run prettier-write
	terraform fmt -recursive

fmt-check:
	yarn run prettier-check
	terraform fmt -recursive -check

setup-git-hooks:
	rm -rf .git/hooks
	(cd .git && ln -s ../.git-hooks hooks)

reload: reload-prom reload-am

reload-prom:
	curl -X POST http://127.0.0.1:9090/-/reload

reload-am:
	curl -X POST http://127.0.0.1:9093/-/reload

cleanup:
	rm -rf data

install-simple-grafana:
	helm upgrade --install simple-grafana \
		--repo https://helm.sikalabs.io simple-grafana \
		--namespace simple-grafana \
		--create-namespace \
		--values ./kubernetes/values/simple-grafana.values.yml
