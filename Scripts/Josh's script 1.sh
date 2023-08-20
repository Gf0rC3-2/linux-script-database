#!/bin/bash


# adds users from a file
filename="addUsers.txt"

while IFS= read -r line; do
   sudo useradd -m -p "123taipan" "$line"
done < "$filename"

# deletes users from a file
filename="delUsers.txt"

while IFS= read -r line; do
   sudo deluser "$line"
done < "$filename"

# makes users from a file admin
filename="addAdmin.txt"

while IFS= read -r line; do
   sudo usermod -aG sudo "$line"
done < "$filename"

# takes away admin privileges from users in a file
filename="delAdmin.txt"

while IFS= read -r line; do
   sudo deluser "$line" sudo
done < "$filename"
