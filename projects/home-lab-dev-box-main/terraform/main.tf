resource "proxmox_vm_qemu" "dev_box" {
  # Number of VMs to create
  count = 1

  # Name of the VM
  name = "dev-box-${count.index + 1}"

  # Proxmox VE host
  target_node = var.pm_hostname
 
  # VM Template to clone from
  clone = var.template_vm_name

  # Description of the VM
  desc = "Dev box"
  
  # Top level VM settings
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  ipconfig0 = "ip=${var.vm_ip}${count.index + 1}/24,gw=${var.vm_gateway}"
  
  # Disks settings
  disk {
    size = "10G"
    type = "scsi"
    storage = "local-lvm"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  # SSH keys
  #sshkeys = <<EOF
  #${var.ssh_key}
  #EOF
}