include .env
export

MAKE := make -s

WATCH_REFRESH ?= 3 # seconds

DOCKER_COMPOSE           := docker-compose
DOCKER_COMPOSE_RUN_FLAGS := --rm -v ./thumbor.conf:/thumbor/thumbor.conf
DOCKER_COMPOSE_RUN       := $(DOCKER_COMPOSE) run $(DOCKER_COMPOSE_RUN_FLAGS) -p $(THUMBOR_PORT):$(THUMBOR_PORT) $(THUMBOR_NAME)

default: docker-run

run: docker-run

docker-build:
	$(DOCKER_COMPOSE) build

docker-rebuild:
	$(DOCKER_COMPOSE) build --no-cache

docker-%:
	$(DOCKER_COMPOSE_RUN) $(MAKE) $*

up:
	$(DOCKER_COMPOSE) up

down:
	$(DOCKER_COMPOSE) down

logs:
	@$(DOCKER_COMPOSE) logs -f

watch:
	@watch -n $(WATCH_REFRESH) $(DOCKER_COMPOSE) ps

clean:
	$(DOCKER_COMPOSE) down -v --rmi local --remove-orphans
	@docker system prune -f

.PHONY: run docker-build docker-rebuild docker-binded-% docker-% up down logs watch clean
