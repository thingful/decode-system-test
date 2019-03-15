
DB := policystore

.PHONY: start
start:
	@docker-compose up

.PHONY: build
build:
	@docker-compose build

.PHONY: stop
stop:
	@docker-compose stop

.PHONY: teardown
teardown:
	@docker-compose down -v

.PHONY: psql
psql:
	@docker-compose start postgres
	@docker-compose exec postgres psql -U decode $(DB)

.PHONY: redeploy
redeploy:
	@docker-compose stop
	@git pull
	@docker-compose pull
	@docker-compose up -d
