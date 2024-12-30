terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc6"
    }
  }
  required_version = ">= 1.0.0"
}

provider "proxmox" {
    pm_api_url      = "https://<IP>:8006/api2/json"
    pm_user         = "root@pam"
    pm_password     = ""
    pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "pfsense" {
    name        = "pfsense"
    desc        = "Router system, general networkcontroller"
    target_node = "gate"       # Node name in Proxmox

    # Sizing
    cores      = 1
    sockets    = 1
    memory     = 2048

    # Disk settings
    disk {
      size              = "20G"
      type              = "scsi"
      storage           = "local-lvm"
    }

    # Network settings (Adjust bridge and VLAN as needed)
    network {
      model          = "virtio"
      bridge         = "vmbr0"
    }
    
    iso = "local:iso/pfSense-CE-2.7.2-RELEASE-amd64.iso"

    # Optional: Boot from Cloud-Init disk
    bootdisk = "scsi0"

    onboot = true

}

output "vm_id" {
  description = "Example VM ID"
  value       = proxmox_vm_qemu.pfsense.vmid
}