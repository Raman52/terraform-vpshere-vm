variable "vsphere_user" {
  description = "The vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "The vSphere password"
  type        = string
  sensitive   = true
}
variable "vsphere_server" {
  description = "The vSphere server IP or hostname"
  type        = string
}
variable "vsphere_datacenter" {
  description = "The name of the datacenter in vSphere"
  type        = string
}

variable "vsphere_datastore" {
  description = "The name of the datastore where VMs and disks are stored"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}
variable "vsphere_network" {
  description = "The name of the vSphere network to connect the virtual machine."
  type        = string
}