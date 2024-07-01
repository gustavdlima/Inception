# Define the project name
name = inception

# Define the paths to files and scripts
ENV_FILE := srcs/.env
MAKE_DIR_SCRIPT := srcs/requirements/wordpress/tools/make_dir.sh
DOCKER_COMPOSE_FILE := srcs/docker-compose.yml

# Target: Launch the configuration
all:
	@bash $(MAKE_DIR_SCRIPT)
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d

# Target: Build and launch the configuration
up:
	@bash $(MAKE_DIR_SCRIPT)
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

# Target: Stop the configuration
down:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) down

# Target: Rebuild and launch the configuration
re: down
	@docker-compose -f $(DOCKER_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

# Target: Clean the configuration
clean: down
	@docker system prune -a

# Target: Completely clean all configurations
fclean:
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

.PHONY: all up down re clean fclean
