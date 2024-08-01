#!/bin/bash
 
# Variables
BASE_HOME="/home"
DESTINATION="/shared-home"
WORK_DESTINATION="/shared-workspace"
MAX_SIZE=10737418240  # 10 GB in bytes
 
# Loop through each user home directory
for USER_HOME in "$BASE_HOME"/*; do
  if [ -d "$USER_HOME" ]; then
    USER=$(basename "$USER_HOME")
    WORKSPACE_DIR="$USER_HOME/_workspace"
    EXCLUDE_DIR="$USER_HOME/_workspace"
    EXCLUDE_DIRS=("--exclude=.cache" "--exclude=_workspace")
    
    echo "Checking $USER's home directory..."
 
    # Calculate the size of the user's home directory excluding the workspace directory
    CURRENT_SIZE=$(du -sb --exclude="$EXCLUDE_DIR" "$USER_HOME" | awk '{print $1}')
    
    if [ "$CURRENT_SIZE" -le "$MAX_SIZE" ]; then
      echo "Size of $USER's home directory (excluding _workspace) is less than or equal to 10 GB."
      
      # Run rsync excluding the workspace directory
      rsync -avh --progress --exclude "${EXCLUDE_DIRS[@]}" "$USER_HOME" "$DESTINATION/"
      echo "=========================================================================="
     
    else
      echo "Size of $USER's home directory (excluding _workspace) is greater than 10 GB."
      
      # Run rsync for the entire home directory
      #rsync -av "$USER_HOME" "$DESTINATION/$USER-home"
    fi
 
    # Check if the workspace directory exists and rsync it if it does
    if [ -d "$WORKSPACE_DIR" ]; then
      echo "_workspace directory exists for $USER. Starting rsync..."
      rsync -avh --progress "$WORKSPACE_DIR" "$WORK_DESTINATION/$USER/"
      echo "=============================================================="
    else
      echo "$USER does not have a _workspace directory."
    fi
    
    #echo "rsync for $USER completed."
  fi
done
