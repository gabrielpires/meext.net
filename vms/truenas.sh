#!/bin/bash

# Configuration
export VM_ID=100
VM_NAME="truenas"
ISO_PATH="iso/TrueNAS-13.3-U1.iso"
DISK_SIZE="32"
MEMORY="16384"
CORES="4"
SOCKETS="1"
BRIDGE_NET0="vmbr0"
DISK_ID1="/dev/disk/by-id/ata-ST4000NE001-2MA101_WS258WS3"
DISK_ID2="/dev/disk/by-id/ata-ST4000NE001-2MA101_WS257VN5"


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
        --scsi1 $DISK_ID1,cache=writeback \
        --scsi2 $DISK_ID2,cache=writeback \
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