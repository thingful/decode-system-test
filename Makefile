
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
