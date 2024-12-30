#!/bin/bash

# Configuration
VM_ID=100
VM_NAME="pfsense"
ISO_PATH="iso/pfSense-CE-2.7.2-RELEASE-amd64.iso"
DISK_SIZE="20"
MEMORY="2048"
CORES="1"
SOCKETS="1"
BRIDGE_NET0="vmbr0"
BRIDGE_NET1="vmbr1"
BRIDGE_NET2="vmbr2"

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
        --net1 virtio,bridge=$BRIDGE_NET1 \
        --net2 virtio,bridge=$BRIDGE_NET2 \
        --scsi0 local-lvm:$DISK_SIZE \
        --cdrom local:$ISO_PATH \
        --boot order=scsi0;ide2
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
    echo "Usage: $0 <TARGET_VM> {create|config|start|stop|destroy}"
    exit 1
fi

TARGET_VM=$1
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
        echo "Usage: $0 <TARGET_VM> {create|config|start|stop|destroy}"
        exit 1
        ;;
esac