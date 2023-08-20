#!/bin/bash

# Check if the script is being run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Backup the original /etc/login.defs file
cp /etc/login.defs /etc/login.defs.backup

# Set password hashing algorithm and parameters
echo "Setting up secure password hashing..."
echo "ENCRYPT_METHOD SHA512" >> /etc/login.defs
echo "SHA_CRYPT_MIN_ROUNDS 5000" >> /etc/login.defs

# Update existing user passwords with the new configuration
echo "Updating existing user passwords..."
pwconv

echo "Secure password hashing is now enabled."

# Clean up backup file
rm /etc/login.defs.backup

# Display message about the importance of strong passwords
echo "Remember to encourage users to use strong and unique passwords!"
