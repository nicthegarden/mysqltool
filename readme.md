Explanation:
Configuration File (config.cfg):

	Stores the database user, password, and retention days.

    Main Script (mysqltool.sh):
        Reads the configuration file located in the same directory as the script.
        Uses the configuration variables for backup and restore operations.
        Functions are similar to the previous version but now use variables from the configuration file.

Usage:

    Create the configuration file config.cfg next to the script mysqltool.sh.
    Fill in the configuration file with the appropriate values.
    Make the script executable:

bash

    chmod +x mysqltool.sh

Run the script with the desired database name, backup directory, and option:

bash

    ./mysqltool.sh database_name  backup

or

bash

    ./mysqltool.sh database_name  restore

This setup allows you to easily manage your MySQL backups and restorations by changing settings in the configuration file without modifying the script itself.
