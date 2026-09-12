YAML = ./srcs/docker-compose.yml
ENV = ./srcs/.env
LOGIN = $(shell grep -m1 '^LOGIN=' $(ENV) 2>/dev/null | cut -d= -f2-)
VOL_DIR = /home/$(LOGIN)/data

all: up

dirs:
	@test -n "$(LOGIN)" || { echo "LOGIN is not set in $(ENV)"; exit 1; }
	@mkdir -p $(VOL_DIR)/wordpress
	@mkdir -p $(VOL_DIR)/mariadb

up: dirs build
	@docker compose -f $(YAML) up
build:
	@docker compose -f $(YAML) build
ps:
	@docker compose -f $(YAML) ps
logs:
	@docker compose -f $(YAML) logs
down:
	@docker compose -f $(YAML) down

prune: rm
	@docker compose -f $(YAML) down --rmi all
rm:
	@docker compose -f $(YAML) down -v --remove-orphans
	@sudo rm -rf $(VOL_DIR)/wordpress/*
	@sudo rm -rf $(VOL_DIR)/mariadb/*
re: prune up

.PHONY: all dirs up build ps logs down prune rm re
