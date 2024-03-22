#!/usr/bin/bash

# Script to rsync data from a source directory to a destination directory

# Source directories
SOURCEDIR="/home/$USER/JohnJay/Bash"

# Destination directory
DESTDIR="/home/$USER/Backup"

# Check if dir exists and if it does not then create it 
# This approach vs a blind mkdir will be 192 system calls
#if [ ! -d /home/$USER/Backup ]; then
#	mkdir -p /home/$USER/Backup
#fi

# Using a blind mkdir will move the script to using 238 system calls
mkdir -p /home/$USER/Backup

# Excluded directories
XDIR='.*'
#exclude_dir2=".local"

# Rsync options
RSYNCOPT="-av --exclude=$XDIR --no-owner --no-group"

# Perform the rsync
rsync $RSYNCOPT "$SOURCEDIR" "$DESTDIR"
