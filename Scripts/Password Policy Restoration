#!/bin/bash

# Define the backup file path
backup_file="/etc/login.defs.bak"

# Check if the backup file exists
if [[ -f "$backup_file" ]]; then
    # Restore the backup file
    sudo cp "$backup_file" /etc/login.defs
    echo "Original login.defs file has been restored."
else
    echo "Backup file does not exist. No changes made."
fi

# Cleanup
unset backup_file
