.PHONY: stop-ddev clean-ddev up down

up:
	docker compose up -d

down: clean

# Stop all running DDEV containers
stop-ddev:
	@containers=$$(docker ps -q --filter 'name=ddev*'); \
	if [ -n "$$containers" ]; then \
		docker stop $$containers; \
	else \
		echo "No running DDEV containers to stop"; \
	fi

# Remove all DDEV containers (stopped and running)
clean-ddev:
	@containers=$$(docker ps -aq --filter 'name=ddev*'); \
	if [ -n "$$containers" ]; then \
		docker rm $$containers; \
	else \
		echo "No DDEV containers to remove"; \
	fi

# Stop and remove all DDEV containers in one command
clean: stop-ddev clean-ddev
