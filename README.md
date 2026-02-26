Linux File Backup Script

A simple Bash script to create timestamped backups of a directory and rotate old backups.

Features

Creates ZIP backups with timestamp

Keeps latest 5 backups

Deletes older backups automatically

Basic logging support

Designed to run with cron

Usage
./file_backup.sh <source_directory> <backup_directory>

Example:

./file_backup.sh /var/www /home/ubuntu/backups
How It Works

Creates backup in format:

backup_YYYY-MM-DD-HH-MM-SS.zip

Stores it in the destination directory

Checks total backup files

Keeps the newest 5 and removes older ones safely
