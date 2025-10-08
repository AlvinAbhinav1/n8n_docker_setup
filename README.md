# n8n Docker Compose Setup

A complete Docker Compose setup for n8n workflow automation with PostgreSQL and Redis, including deployment tools and backup scripts.

## 🚀 Quick Start

This project includes a comprehensive Makefile that simplifies deployment and management of your n8n instance both locally and on remote servers.

## 📋 Prerequisites

### Local Development

- Docker and Docker Compose installed
- Make utility (pre-installed on macOS and most Linux distributions)

### Remote Deployment (DigitalOcean)

- DigitalOcean account with a droplet
- SSH access to your droplet
- Docker and Docker Compose installed on the droplet

## 🛠 Setup

### 1. Clone and Configure

```bash
git clone <your-repository>
cd n8n_docker_setup
```

### 2. Create Environment File

Create a `.env` file in the project root with the following variables:

```bash
# PostgreSQL Configuration
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=your_secure_password
POSTGRES_NON_ROOT_USER=n8n
POSTGRES_NON_ROOT_PASSWORD=your_secure_password

# n8n Configuration  
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_admin_password

# Database Connection
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=your_secure_password

# Redis Configuration
QUEUE_BULL_REDIS_HOST=redis
QUEUE_BULL_REDIS_PORT=6379

# Execution Configuration
EXECUTIONS_PROCESS=main
N8N_METRICS=true

# For DigitalOcean deployment
DROPLET_USER=root
DROPLET_IP=your.droplet.ip.address
```

## 🎯 Make Commands Reference

### Local Development Commands

#### `make up`

Starts all services locally in detached mode.

```bash
make up
```

**What it does:**

- Starts n8n, PostgreSQL, and Redis containers
- Creates necessary Docker volumes
- Runs containers in background

#### `make down`

Stops and removes all running containers.

```bash
make down
```

**What it does:**

- Stops all running containers
- Removes containers but preserves volumes and data

#### `make restart`

Restarts all services without rebuilding.

```bash
make restart
```

**What it does:**

- Restarts all containers with current configuration
- Useful for applying environment variable changes

#### `make logs`

Shows real-time logs from all services.

```bash
make logs
```

**What it does:**

- Displays logs from n8n, PostgreSQL, and Redis
- Follows log output in real-time (Ctrl+C to exit)

#### `make ps`

Shows status of all containers.

```bash
make ps
```

**What it does:**

- Lists all containers with their current status
- Shows ports, names, and health status

### Remote Deployment Commands

#### `make ssh`

Connect to your DigitalOcean droplet via SSH.

```bash
make ssh
```

**Prerequisites:**

- Set `DROPLET_USER` and `DROPLET_IP` in your `.env` file
- SSH key configured for the droplet

#### `make copy`

Copies your local n8n project to the droplet.

```bash
make copy
```

**What it does:**

- Uses rsync to efficiently copy files to remote server
- Preserves file permissions and timestamps
- Only copies changed files

#### `make update`

Updates n8n on the remote droplet.

```bash
make update
```

**What it does:**

- Pulls latest Docker images on remote server
- Restarts containers with new images
- Removes orphaned containers

## 📖 Complete Tutorial

### Local Development Workflow

1. **Initial Setup**
   ```bash
   # Create your environment file
   cp .env.example .env  # Edit with your values
   
   # Start the stack
   make up
   
   # Check if everything is running
   make ps
   ```

2. **Access n8n**
   - Open your browser to `http://localhost:5678`
   - Login with credentials from your `.env` file

3. **Monitor and Debug**
   ```bash
   # View logs
   make logs
   
   # Check container status
   make ps
   
   # Restart if needed
   make restart
   ```

4. **Stop When Done**
   ```bash
   make down
   ```

### DigitalOcean Deployment Workflow

1. **Prepare Your Droplet**
   ```bash
   # SSH into your droplet
   make ssh
   
   # Install Docker and Docker Compose
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   sudo apt install docker-compose-plugin
   ```

2. **Deploy n8n**
   ```bash
   # Copy files to droplet
   make copy
   
   # SSH and start services
   make ssh
   cd n8n
   make up
   ```

3. **Verify Deployment**
   ```bash
   # Check status on droplet
   make ps
   make logs
   ```

4. **Update n8n**
   ```bash
   # From your local machine
   make update
   ```

## 🔧 Advanced Usage

### Database Backups

The project includes automated backup scripts:

```bash
# Make backup script executable
chmod +x backup_postgres.sh

# Run manual backup
./backup_postgres.sh

# Set up automated backups (on droplet)
crontab -e
# Add the line from backup_cron_example.txt
```

### Troubleshooting

#### Check Container Health

```bash
make ps
make logs
```

#### Reset Everything

```bash
make down
docker system prune -f
make up
```

#### Database Issues

```bash
# Check PostgreSQL logs specifically
docker compose logs postgres

# Access PostgreSQL directly
docker compose exec postgres psql -U n8n -d n8n
```

### Custom Configuration

#### Modify Docker Compose

Edit `docker-compose.yml` to customize:

- Port mappings
- Volume mounts
- Environment variables
- Resource limits

#### Add Custom Commands

Extend the `Makefile` with your own commands:

```makefile
backup:
    ./backup_postgres.sh

clean:
    docker system prune -f
    docker volume prune -f
```

## 🌐 Production Considerations

### Security

- Use strong passwords in `.env`
- Configure firewall on your droplet
- Set up SSL certificates (consider using Caddy or nginx)
- Regularly update Docker images

### Monitoring

- Set up log rotation
- Monitor disk space for backups
- Consider using Docker health checks

### Scaling

- Use Docker Swarm or Kubernetes for multiple nodes
- Set up load balancing for high availability
- Configure Redis clustering for better performance

## 📁 Project Structure

```text
n8n_docker_setup/
├── docker-compose.yml          # Main Docker Compose configuration
├── Makefile                    # Automation commands
├── .env                        # Environment variables (create this)
├── backup_postgres.sh          # Database backup script
├── backup_cron_example.txt     # Cron job example
├── DEPLOY_TO_DIGITALOCEAN.md   # Detailed deployment guide
└── README.md                   # This file
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Test your changes locally with `make up`
4. Submit a pull request

## 📝 License

This project is open source. Please check the license file for details.

---

**Need Help?** Check the logs with `make logs` or review the troubleshooting section above.
