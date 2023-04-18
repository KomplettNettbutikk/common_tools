#!/bin/bash

## ##

# Set backup directory path
BACKUP_DIR="/db-backups"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi

# Set backup interval and retention time in hours with default values
BACKUP_INTERVAL_HOURS="${1:-1}"
BACKUP_RETENTION_HOURS="${2:-24}"

# Calculate backup interval in seconds
BACKUP_INTERVAL_SECONDS=$(($BACKUP_INTERVAL_HOURS * 3600))

# Calculate backup retention time in seconds
BACKUP_RETENTION_SECONDS=$(($BACKUP_RETENTION_HOURS * 3600))

# Loop forever
while true; do

  # Create backup filename with current timestamp
  BACKUP_FILENAME="$BACKUP_DIR/db-backup-$(date +%Y-%m-%d_%H-%M-%S).sql"

  # Take database backup
  mysqldump --all-databases > "$BACKUP_FILENAME"

  # Delete backups older than retention time
  find "$BACKUP_DIR" -name "db-backup*.sql" -type f -mmin "+$BACKUP_RETENTION_MINUTES" -delete

  # Sleep until next backup interval
  sleep "$BACKUP_INTERVAL_SECONDS"

done
