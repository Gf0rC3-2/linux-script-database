#!/bin/bash

# Prompt for the new password
read -s -p "Enter the new password for all users: " new_password
echo

# Get a list of all users
users=$(cut -d: -f1 /etc/passwd)

# Change passwords for each user
for user in $users; do
    echo "$user:$new_password" | sudo chpasswd
done

echo "Passwords have been changed for all users."
