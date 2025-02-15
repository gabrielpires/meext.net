#!/bin/bash

# -----------------------------------------------------------------------------
# Function: checkTarget
# Parameters:
#   $1 - target_path: The directory path to check/create.
# Description:
#   Checks if the given target_path exists. If it does not exist, the function
#   creates it (including any intermediate directories). Throughout the process,
#   it logs informative messages.
# -----------------------------------------------------------------------------
checkTarget() {
    local target_path="$1"

    if [ -z "$target_path" ]; then
        echo "[ERROR] No target path provided to checkTarget."
        return 1
    fi

    if [ -d "$target_path" ]; then
        echo "[INFO] Target path '$target_path' already exists."
    else
        echo "[INFO] Target path '$target_path' does not exist. Creating it..."
        mkdir -p "$target_path"
        if [ $? -eq 0 ]; then
            echo "[INFO] Successfully created target path '$target_path'."
        else
            echo "[ERROR] Failed to create target path '$target_path'."
            return 1
        fi
    fi
}

# -----------------------------------------------------------------------------
# Function: mountVolume
# Parameters:
#   $1 - target_path: The local mount point.
#   $2 - volume_addr: The network volume address (e.g., //server/share).
#   $3 - credentials_path: Path to the credentials file.
# Description:
#   Checks if the volume is already mounted on the target_path. If not, it attempts
#   to mount the volume using the CIFS filesystem and the provided credentials.
# -----------------------------------------------------------------------------
mountVolume() {
    local target_path="$1"
    local volume_addr="$2"
    local credentials_path="$3"

    # Validate parameters.
    if [ -z "$target_path" ] || [ -z "$volume_addr" ] || [ -z "$credentials_path" ]; then
        echo "[ERROR] Missing parameter(s). Usage: mountVolume <target_path> <volume_addr> <credentials_path>"
        return 1
    fi

    # Ensure the target directory exists.
    checkTarget "$target_path"
    if [ $? -ne 0 ]; then
        echo "[ERROR] Unable to verify or create target path '$target_path'. Aborting mount."
        return 1
    fi

    # Check if the volume is already mounted.
    if grep -qs " $target_path " /proc/mounts; then
        echo "[INFO] Volume already mounted on '$target_path'."
    else
        echo "[INFO] Volume not mounted on '$target_path'. Attempting to mount..."
        mount -t cifs "$volume_addr" "$target_path" -o credentials="$credentials_path"
        if [ $? -eq 0 ]; then
            echo "[INFO] Successfully mounted '$volume_addr' on '$target_path'."
        else
            echo "[ERROR] Failed to mount '$volume_addr' on '$target_path'."
            return 1
        fi
    fi
}
