# Makefile for n8n Docker Compose Deployment on DigitalOcean

.PHONY: up down restart logs ps ssh copy update

up:
	docker compose up -d

down:
	docker compose down

restart:
	docker compose restart

logs:
	docker compose logs -f

ps:
	docker compose ps

ssh:
	ssh $(DROPLET_USER)@$(DROPLET_IP)

copy:
	rsync -avz ./n8n/ $(DROPLET_USER)@$(DROPLET_IP):/home/$(DROPLET_USER)/n8n/

update:
	ssh $(DROPLET_USER)@$(DROPLET_IP) 'cd /home/$(DROPLET_USER)/n8n && docker compose pull && docker compose up -d --remove-orphans'

# Usage:
# make up        # Start services locally
# make down      # Stop services locally
# make logs      # View logs
# make ps        # Show status
# make copy      # Copy n8n folder to droplet (set DROPLET_USER and DROPLET_IP)
# make ssh       # SSH into droplet
# make update    # Pull and restart on droplet
