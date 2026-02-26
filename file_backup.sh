#!/bin/bash 

function display_usage() {
	echo " ./file_backup.sh <source path> <dest path>"
}

if [ $# -eq 0 ]; then
	display_usage
	exit 1
fi

src_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2
LOG_FILE="${backup_dir}/backup.log"

if [ ! -d "$src_dir" ]; then
    echo "Source directory does not exist"
    exit 1
fi

if [ ! -d "$backup_dir" ]; then
    echo "Backup directory does not exist"
    exit 1
fi

function create_backup() {

	if zip -r "${backup_dir}/backup_${timestamp}.zip" "${src_dir}" > /dev/null; then
    		echo "Backup generated successfully"
		echo "$(date) - Backup successful" >> "$LOG_FILE"
	else
    		echo "Backup failed"
		echo "$(date) - Backup failed" >> "$LOG_FILE"
    		exit 1
	fi
}

function perform_rotation() {
	mapfile -t backups < <(find "$backup_dir" -maxdepth 1 -name "backup_*.zip" -printf "%T@ %p\n" 2>/dev/null | sort 	 -nr | awk '{print $2}')

	if [ "${#backups[@]}" -gt 5 ]; then
		echo "performing rotation for 5 days"

		backups_to_remove=(${backups[@]:5})

		for backup in "${backups[@]:5}"; do
        		if rm -f -- "$backup"; then
            			echo "$(date) - Removed old backup: $backup" >> "$LOG_FILE"
        		else
            			echo "$(date) - Failed to remove: $backup" >> "$LOG_FILE"
        		fi
    		done
	fi
}



create_backup
perform_rotation


