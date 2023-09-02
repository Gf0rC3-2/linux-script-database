#!/bin/bash

# ROOT CHECKER
# Check if the script is being run with superuser privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    echo "EXITING..."
    exit 1
fi

# Step 2: Update, Install ClamTk, and Enable Firewall
echo "WARNING: This step will update the system, install ClamTk, and enable the firewall."
read -p "Do you want to continue? (y/n): " update_confirm
if [[ $update_confirm = "y" ]]; then
    echo "Running..."
    apt-get update
    apt-get upgrade -y
    apt-get install clamtk -y
    apt-get upgrade clamtk
    ufw enable
fi
    echo "Operation cancelled"




# Step 4: Remove audio and/or video and/or other file types
# Prompt the user to select the files to remove
echo "Which files do you want to remove?"
echo "0. No files"
echo "1. Audio files"
echo "2. Video files"
echo "3. Both audio and video files"
echo "4. Other files (Specify file extensions)"


read -p "Enter the corresponding number: " choice

# Define variables for file extensions
audio_extensions=".mp3 .wav .aac .flac .ogg"
video_extensions=".mp4 .avi .mkv .wmv .mov"
other_extensions=""

# Process user's choice
case $choice in
    0)
        echo "Operation canceled"
        ;;
    1)
        extensions="$audio_extensions"
        ;;
    2)
        extensions="$video_extensions"
        ;;
    3)
        extensions="$audio_extensions $video_extensions"
        ;;
    4)
        read -p "Enter the file extensions to remove (space-separated): " other_extensions
        extensions="$other_extensions"
        ;;
    *)
        echo "Invalid choice. Operation canceled."
        ;;
esac

# Confirm file removal
read -p "Are you sure you want to remove files with the following nstall Required Packages
# Install required packages using apt-get or any package manager
# sudo apt-get instalextensions: $extensions? (y/n) " confirm

if [[ $confirm == "y" ]]; then
    # Remove files based on selected extensions
    find / -type f \( -name "*$extensions" \) -delete
    echo "Files with extensions $extensions have been removed."
else
    echo "File removal operation cancelled."
fi

# Step 7: Set Automatic Updates
echo "WARNING: This step will enable automatic updates for security updates."
read -p "Do you want to continue? (y/n): " update_confirm
if [[ $update_confirm != "y" ]]; then
    echo "Operation cancelled."
else
    # Enable automatic updates for security updates
    sed -i 's/APT::Periodic::Update-Package-Lists "0";/APT::Periodic::Update-Package-Lists "1";/g' /etc/apt/apt.conf.d/20auto-upgrades
    sed -i 's/APT::Periodic::Unattended-Upgrade "0";/APT::Periodic::Unattended-Upgrade "1";/g' /etc/apt/apt.conf.d/20auto-upgrades
    echo "Automatic updates have been enabled."
fi

# Step 8: Set Password Policy
echo "WARNING: This step will change the password policy."
read -p "Do you want to continue? (y/n): " update_confirm
if [[ $update_confirm != "y" ]]; then
    echo "Operation cancelled."
else
    # Generate a random password
    generate_password() {
        pw_length=12  # Change the length as per your requirements  
        pw_characters="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        password=$(tr -dc "$pw_characters" < /dev/urandom | fold -w "$pw_length" | head -n 1)
        echo "$password"
    }

    # Generate and apply new password to root and 'ubuntu' user
    new_password=$(generate_password)

    echo "Generated Password: $new_password"

    # Change root password
    echo "Changing root password..."
    echo "root:$new_password" | sudo chpasswd

    # Change 'ubuntu' user password
    echo "Changing 'ubuntu' user password..."
    echo "ubuntu:$new_password" | sudo chpasswd

    # Display new passwords
    echo "New root password: $new_password"
    echo "New 'ubuntu' user password: $new_password"

    # Backup the original /etc/login.defs file
    cp /etc/login.defs /etc/login.defs.backup

    # Change the password policy in /etc/login.defs
    sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t30/' /etc/login.defs
    sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t7/' /etc/login.defs
    sed -i 's/PASS_WARN_AGE\t7/PASS_WARN_AGE\t14/' /etc/login.defs

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
    
    echo "Password policy has been updated."
fi

clamscan -r /
