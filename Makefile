YAML = ./srcs/docker-compose.yml
VOL_DIR = /home/$(USER)/data

all: up
	mkdir -p $(VOL_DIR)/wordpress
	mkdir -p $(VOL_DIR)/mariadb

up: build
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
	@docker system prune -af
rm: down
	@docker rm $$(docker ps -a -q) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@sudo rm -rf $(VOL_DIR)/wordpress/*
	@sudo rm -rf $(VOL_DIR)/mariadb/*
re: prune build up