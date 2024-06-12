variable "pm_token_id" {
  description = "The Token ID for the proxmox user"
  type        = string
  sensitive   = true
}

variable "pm_token_secret" {
  description = "The Token secret for the proxmox user"
  type        = string
  sensitive   = true
}

variable "pm_tls_insecure" {
  description = "Set to true to ignore certificate errors"
  type        = bool
  default     = true
}

variable "pm_host" {
  type        = string
  sensitive   = true
}

variable "pm_hostname" {
  type        = string
  default     = "proxmox"
}

variable "vm_ip" {
  description = "IP start of new VMs"
  type        = string
  sensitive   = true
}

variable "vm_gateway" {
  description = "Gateway of new VMs"
  type        = string
  sensitive   = true
}

variable "template_vm_name" {
  description = "Name of the template VM"
  type        = string
  default     = "ubuntu-2004-cloudinit-template"
}