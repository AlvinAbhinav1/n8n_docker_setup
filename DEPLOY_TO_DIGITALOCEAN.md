# DigitalOcean n8n Docker Compose Deployment Workflow

# 1. Prerequisites

# - DigitalOcean account

# - A Droplet (Ubuntu 22.04 recommended)

# - Docker and Docker Compose installed on the Droplet

# - SSH access to the Droplet

# - Your local n8n project directory with docker-compose.yml and .env

# 2. Steps

# Step 1: Build and push a custom n8n image (optional)

# If you want to use the official image, skip this step.

# docker build -t yourdockerhub/n8n:latest .

# docker push yourdockerhub/n8n:latest

# Step 2: Copy files to the Droplet

scp -r ./n8n root@your_droplet_ip:/root/

# Step 3: SSH into the Droplet

ssh root@your_droplet_ip

# Step 4: Start the stack

cd /root/n8n
docker compose up -d

# Step 5: Check status

# docker compose ps

# docker compose logs -f

# Step 6: (Optional) Set up a domain and SSL

# - Point your domain's A record to your Droplet's IP

# - Use a reverse proxy (e.g., nginx, Caddy, or Traefik) for SSL

# - Use Let's Encrypt for free SSL certificates

# Step 7: Update n8n

# docker compose pull

# docker compose down

# docker compose up -d

# Notes:

# - Change 'root' to your actual user if not using root

# - Secure your Droplet (firewall, SSH keys, etc.)

# - For production, consider backups and monitoring
