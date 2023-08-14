#!/bin/bash

# Backup the original login.defs file
sudo cp /etc/login.defs /etc/login.defs.bak

# Define the desired password policy settings
password_max_days="PASS_MAX_DAYS   90"
password_min_days="PASS_MIN_DAYS   7"
password_warn_age="PASS_WARN_AGE   14"
encrypt_method="ENCRYPT_METHOD  SHA512"

# Update the password policy settings in the login.defs file
sudo sed -i "s/^PASS_MAX_DAYS.*/$password_max_days/" /etc/login.defs
sudo sed -i "s/^PASS_MIN_DAYS.*/$password_min_days/" /etc/login.defs
sudo sed -i "s/^PASS_WARN_AGE.*/$password_warn_age/" /etc/login.defs
sudo sed -i "s/^ENCRYPT_METHOD.*/$encrypt_method/" /etc/login.defs

# Inform the user about the password policy update
echo "Password policy has been updated."

# Print the updated password policy for reference
echo "Updated password policy:"
grep "^PASS" /etc/login.defs

# Cleanup
unset password_max_days
unset password_min_days
unset password_warn_age
unset encrypt_method
