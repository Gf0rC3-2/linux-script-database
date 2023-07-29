!/bin/bash
allowed_file="allowed.txt"
users_file="users.txt"

# Compare the users between the two files
users_to_delete=$(comm -13 <(sort "$allowed_file") <(sort "$users_file"))
users_to_add=$(comm -13 <(sort "$users_file") <(sort "$allowed_file"))

# Ask for confirmation before deleting users
read -p "Are you sure you want to delete the following users: $users_to_delete? (y/n) " confirm_delete
if [[ $confirm_delete == "y" ]]; then
    vim
#edit
