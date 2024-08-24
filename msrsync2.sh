#!/bin/bash

# Function to synchronize user home directories
sync_user_home() {
  local USER_HOME="$1"
  local USER=$(basename "$USER_HOME")
  local WORKSPACE_DIR="$USER_HOME/_workspace"
  local EXCLUDE_DIR="$USER_HOME/_workspace"
  local EXCLUDE_DIRS=("--exclude='.cache/' --exclude='.conda/' --exclude='.apptainer/' --exclude='adm_*' --exclude='_workspace' ")

  echo "Checking ${USER%@*}'s home directory..."

  # Calculate the size of the user's home directory excluding the workspace directory
  local CURRENT_SIZE=$(du -sb --exclude="$EXCLUDE_DIR" "$USER_HOME" | awk '{print $1}')

  if [ "$CURRENT_SIZE" -le "$MAX_SIZE" ]; then
    echo "Size of ${USER%@*}'s home directory (excluding _workspace) is less than or equal to 20 GB: $(date)" >> /var/log/rsync_log/home_sync.out

    # Run rsync excluding the workspace directory
    /usr/local/bin/msrsync3 -p 6 --stats --progress --rsync "-ahvl $EXCLUDE_DIRS" "$USER_HOME" "$DESTINATION"
    echo "=========================================================================="
  else
    echo "Size of ${USER%@*}'s home directory (excluding _workspace) is greater than 20 GB: $(date)" >> /var/log/rsync_log/home_nosync.out
  fi

  # Check if the workspace directory exists and rsync it if it does
  if [ -d "$WORKSPACE_DIR" ]; then
    echo "_workspace directory exists for ${USER%@*}. Starting rsync..." >> /var/log/rsync_log/works_exist.out

    /usr/local/bin/msrsync3 -p 6 --progress --rsync "-ahvl --exclude=adm_*" "$WORKSPACE_DIR/" "$WORK_DESTINATION/${USER%@*}"
    echo "=============================================================="
  else
    echo "${USER%@*} does not have a _workspace directory: $(date)" >> /var/log/rsync_log/work_noexist.out
  fi

  echo "rsync for ${USER%@*} completed." >> /var/log/rsync_log/rsync_complete.out
}

# Function to handle rsync errors
handle_rsync_error() {
  local error_code="$1"
  echo "rsync encountered an error: $error_code" >> /var/log/rsync_log/rsync_errors.out
  # Add additional error handling logic here, such as sending notifications or retrying the synchronization
}

# Main script
BASE_HOME="/home"
DESTINATION="/shared-home"
WORK_DESTINATION="/shared-workspace"
MAX_SIZE=21474836480  # 20 GB in bytes

# Loop through each user home directory
for USER_HOME in "$BASE_HOME"/*; do
  if [ -d "$USER_HOME" ]; then
    sync_user_home "$USER_HOME"
  fi
done
