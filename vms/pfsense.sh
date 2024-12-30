#!/bin/bash

export VM_ID=100

qm create $VM_ID \
  --name "pfsense" \
  --cores 1 \
  --sockets 1 \
  --memory 2048 \
  --scsihw virtio-scsi-pci \
  --net0 virtio,bridge=vmbr0 \
  --net1 virtio,bridge=vmbr1 \
  --net2 virtio,bridge=vmbr2 \
  --scsi0 local-lvm:20 \
  --ide2 local:iso/pfSense-CE-2.7.2-RELEASE-amd64.iso \
  --boot order=scsi0;ide2

qm config $VM_ID
qm start $VM_ID