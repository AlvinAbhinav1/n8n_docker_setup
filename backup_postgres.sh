#!/bin/bash
# backup_postgres.sh
# Backup Postgres database from Docker Compose stack (run on DigitalOcean droplet)
# Usage: ./backup_postgres.sh

set -e

BACKUP_DIR="/home/$(whoami)/n8n_backups"
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
CONTAINER=$(docker compose ps -q postgres)
DB_NAME=${POSTGRES_DB:-n8n}
DB_USER=${POSTGRES_USER:-n8n}
DB_PASS=${POSTGRES_PASSWORD:-n8npass}

mkdir -p "$BACKUP_DIR"

# Run pg_dump inside the postgres container
export PGPASSWORD="$DB_PASS"
docker exec "$CONTAINER" pg_dump -U "$DB_USER" "$DB_NAME" > "$BACKUP_DIR/n8n_postgres_backup_$DATE.sql"

# Optional: Remove backups older than 7 days
tmpfind=$(which gfind || which find)
$tmpfind "$BACKUP_DIR" -type f -name '*.sql' -mtime +7 -delete

echo "Backup complete: $BACKUP_DIR/n8n_postgres_backup_$DATE.sql"
