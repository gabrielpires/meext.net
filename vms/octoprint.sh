#!/bin/bash

# Configuration
export VM_ID=103
VM_NAME="octoprint"
ISO_PATH="iso/debian-12.8.0-amd64-netinst.iso"
DISK_SIZE="20"
MEMORY="2048"
CORES="2"
SOCKETS="1"
BRIDGE_NET0="vmbr0"

# Function: Create VM
create() {
    echo "Creating VM with ID $VM_ID"
    qm create $VM_ID \
        --name "$VM_NAME" \
        --cores $CORES \
        --sockets $SOCKETS \
        --memory $MEMORY \
        --scsihw virtio-scsi-pci \
        --net0 virtio,bridge=$BRIDGE_NET0 \
        --scsi0 local-lvm:$DISK_SIZE \
        --ide2 local:$ISO_PATH,media=cdrom \
        --boot order='scsi0;ide2' \
        --autostart 1
}


# Function: Configure VM
config() {
    echo "Configuring VM with ID $VM_ID"
    qm config $VM_ID
}

# Function: Start VM
start() {
    echo "Starting VM with ID $VM_ID"
    qm start $VM_ID
}

# Function: Stop VM
stop() {
    echo "Stopping VM with ID $VM_ID"
    qm stop $VM_ID
}

# Function: Destroy VM
destroy() {
    echo "Destroying VM with ID $VM_ID"
    qm destroy $VM_ID
}



if [ $# -lt 2 ]; then
    echo "Usage: $0 <VM> {create|config|start|stop|destroy}"
    exit 1
fi

VM=$1
ACTION=$2

case "$ACTION" in
    create)
        create
        ;;
    config)
        config
        ;;
    start)
        start
        ;;
    stop)
        stop
        ;;
    destroy)
        destroy
        ;;
    *)
        echo "Invalid option: $ACTION"
        echo "Usage: $0 <VM> {create|config|start|stop|destroy}"
        exit 1
        ;;
esac