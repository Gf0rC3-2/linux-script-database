#!/bin/bash

# Define the Samba configuration file path
smb_config_file="/etc/samba/smb.conf"

# Function to check if a user is registered with smbpasswd
function is_user_registered {
    local username=$1
    sudo smbpasswd -e -L -q "$username" > /dev/null 2>&1
    return $?
}

# Check if the Samba config file exists
if [ ! -f "$smb_config_file" ]; then
    echo "Samba configuration file not found: $smb_config_file"
    exit 1
fi

# Extract valid users from Samba config
valid_users=$(awk -F= '/^\s*valid users/ {gsub(/[[:space:],]/, "", $2); print $2}' "$smb_config_file")

# Initialize an array to store unauthorized users
unauthorized_users=()

# Loop through valid users and check if registered
for user in $valid_users; do
    is_user_registered "$user"
    if [ $? -ne 0 ]; then
        unauthorized_users+=("$user")
    fi
done

# Output unauthorized users
if [ ${#unauthorized_users[@]} -eq 0 ]; then
    echo "All users are registered with smbpasswd."
else
    echo "The following users are unauthorized:"
    printf "%s\n" "${unauthorized_users[@]}"
fi
