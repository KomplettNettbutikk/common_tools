#!/bin/bash

# Backup script - creates backups of all databases and deletes backups older than a specified time
#
# Usage:
# 1. Download the script from https://raw.githubusercontent.com/KomplettNettbutikk/common_tools/main/db_backup.sh
# 2. Make the script executable: chmod +x db_backup.sh
# 3. Add the script as a cron job using the following one-liner (replace "/path/to/db_backup.sh" with the actual path to the script):
#    (curl -sS https://raw.githubusercontent.com/KomplettNettbutikk/common_tools/main/db_backup.sh > /db_backup.sh && chmod +x /db_backup.sh && crontab -l ; echo "0 * * * * /db_backup.sh 24") | crontab -
#    This will execute the script every hour and retain backups for 24 hours. Replace "24" with the desired retention time in hours.
#
# Note: Running scripts directly from the internet can pose a security risk. Make sure to verify the script content before executing it.

# Set backup directory path
BACKUP_DIR="/db-backups"

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  mkdir "$BACKUP_DIR"
fi

# Check if retention time is provided
if [ -n "$1" ]; then
  # Calculate backup retention time in seconds
  BACKUP_RETENTION_SECONDS=$(($1 * 3600))

  # Delete backups older than retention time
  FIND_COMMAND="find \"$BACKUP_DIR\" -name \"db-backup*.sql\" -type f -mmin \"+$(($1 * 60))\" -delete"
else
  # No retention time provided
  FIND_COMMAND=""
fi

# Create backup filename with current timestamp
BACKUP_FILENAME="$BACKUP_DIR/db-backup-$(date +%Y-%m-%d_%H-%M-%S).sql"

# Take database backup
mysqldump --all-databases > "$BACKUP_FILENAME"

# Delete backups older than retention time (if set)
if [ -n "$FIND_COMMAND" ]; then
  eval "$FIND_COMMAND"
fi
