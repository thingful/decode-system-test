
DB := policystore
TIMESTAMP := $(shell date -u +"%s%3N")

include conf.mk

.PHONY: start
start:
	@docker-compose up -d

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
	@curl -H "Content-Type: application/json" -H "Authorization: Bearer $(API_KEY)" -d '{"dashboardId":$(DASHBOARD_ID),"time":$(TIMESTAMP),"isRegion":false,"text":"Redeployment of all applications","tags":["deploy"]}' http://decode.smartcitizen.me:3000/api/annotations

