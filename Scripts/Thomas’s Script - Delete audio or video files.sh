#!/bin/bash
#finds and destroys all prohibited files

read -p "Are you sure you want to delete all audio/video files? [y/n] " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    find / -type f -name "*.mp4" -o -name "*.mp3" -o -name "*.wav" -o -name "*.avi" -o -name "*.mov" -o -name "*.wmv" -o -name "*.flv" 2>/dev/null | xargs rm
    echo "All video/audio files have been deleted."
else
    echo "No files were deleted."
fi
