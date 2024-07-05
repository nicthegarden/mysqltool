# Readme.md:
## Configuration File (config.cfg):

Stores the database user, password, and retention days.

## Main Script (mysqltool.sh):
Reads the configuration file located in the same directory as the script.
Uses the configuration variables for backup and restore operations.
Functions are similar to the previous version but now use variables from the configuration file.

## Usage:

Create the configuration file config.cfg next to the script mysqltool.sh.
Fill in the configuration file with the appropriate values.
Make the script executable:

```bash
chmod +x mysqltool.sh
```

Run the script with the desired database name, backup directory, and option:

## Backup:

```bash
    ./mysqltool.sh database_name  backup
```

## Restore :

```bash
    ./mysqltool.sh database_name  restore
```

This setup allows you to easily manage your MySQL backups and restorations by changing settings in the configuration file without modifying the script itself.


## Configuration File Structure (config.cfg)
** This files needs to be at the same place as the root of the script mysqltool.sh ** 

DB_USER=PUT_IN_THE_USERNAME_OF_THE_DATABASE
DB_PASSWORD=PUT_IN_THE_PASSWORD_OF_THE_DATABASE
BACKUP_DIR=/path/to/backup/the/database #Backup Directory where you can backup your thing
RETENTION_DAYS=7 #the backup maximum life 
MAX_BACKUP_COUNT=2 #the maximum number of backup allowed


## Crontab Usage 
Make sure you are running your command as the user you want it to run
```bash
    crontab -e
```
# m h  dom mon dow   command
```bash
        0 * * * * /root/dobackup.sh
```
