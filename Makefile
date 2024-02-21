YAML = ./srcs/docker-compose.yml

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
	@sudo rm -rf /home/$(USER)/data/wordpress/*
	@sudo rm -rf /home/$(USER)/data/mariadb/*
re: prune build up