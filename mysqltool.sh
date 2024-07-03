#!/bin/bash

# Load configuration file
CONFIG_FILE="$(dirname "$0")/config.cfg"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi
source "$CONFIG_FILE"

# Function to backup the database
backup_database() {
    local db_name=$1
    local backup_dir=$2
    CURRENT_DATE_TIME=$(date +"%Y-%m-%d_%H-%M-%S")
    BACKUP_FILE="${backup_dir}/${db_name}_${CURRENT_DATE_TIME}.sql"

    # Backup the database
    mysqldump -u $DB_USER -p$DB_PASSWORD $db_name > $BACKUP_FILE

    if [ $? -eq 0 ]; then
        echo "Database backup successful: $BACKUP_FILE"
        
        # Compress the backup
        gzip $BACKUP_FILE

        # Cleanup old backups
        find $backup_dir -name "${db_name}_*.sql.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
        echo "Old backups cleaned up."
    else
        echo "Error backing up database."
    fi
}

# Function to list backups
list_backups() {
    local db_name=$1
    local backup_dir=$2
    echo "Available backups for database '$db_name':"
    backups=($(ls $backup_dir/${db_name}_*.sql.gz))
    for i in "${!backups[@]}"; do
        echo "$i) $(basename ${backups[$i]})"
    done
}

# Function to restore a selected backup
restore_backup() {
    local db_name=$1
    local backup_file=$2
    gunzip < $backup_file | mysql -u $DB_USER -p$DB_PASSWORD $db_name
    if [ $? -eq 0 ]; then
        echo "Backup $(basename $backup_file) restored successfully."
    else
        echo "Error restoring backup $(basename $backup_file)."
    fi
}

# Function to handle restore option
handle_restore() {
    local db_name=$1
    local backup_dir=$2
    list_backups $db_name $backup_dir

    echo "Enter the number of the backup you want to restore:"
    read backup_number

    if [[ $backup_number =~ ^[0-9]+$ ]] && [ $backup_number -ge 0 ] && [ $backup_number -lt ${#backups[@]} ]; then
        backup_to_restore=${backups[$backup_number]}
        echo "You have selected $(basename $backup_to_restore)."
        
        echo "Are you sure you want to restore this backup? This will overwrite the current database. (yes/no)"
        read confirmation
        if [ "$confirmation" == "yes" ]; then
            restore_backup $db_name $backup_to_restore
        else
            echo "Restore operation cancelled."
        fi
    else
        echo "Invalid selection. Exiting."
        exit 1
    fi
}

# Main script
if [ $# -ne 3 ]; then
    echo "Usage: $0 database_name backup_directory {backup|restore}"
    exit 1
fi

DB_NAME=$1
BACKUP_DIR=$2
ACTION=$3

case "$ACTION" in
    backup)
        backup_database $DB_NAME $BACKUP_DIR
        ;;
    restore)
        handle_restore $DB_NAME $BACKUP_DIR
        ;;
    *)
        echo "Usage: $0 database_name backup_directory {backup|restore}"
        exit 1
        ;;
esac
