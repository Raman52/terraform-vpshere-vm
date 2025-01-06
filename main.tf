provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = "Cluster/Resources"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "terrav"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
resource "vsphere_tag_category" "vm_tags_category" {
  name        = "VM-Category"
  cardinality = "MULTIPLE" # Allows multiple tags per object

  associable_types = [
    "VirtualMachine"
  ]
}

resource "vsphere_tag" "environment_test" {
  name        = "Environment-Test"
  category_id = vsphere_tag_category.vm_tags_category.id
  description = "Tag for environment classification"
}

resource "vsphere_tag" "owner_ramanjeet" {
  name        = "Owner-Ramanjeet"
  category_id = vsphere_tag_category.vm_tags_category.id
  description = "Tag for ownership identification"
}


resource "vsphere_virtual_machine" "vm" {
  name             = "var_name"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus  = 1
  memory    = 4096
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "Hard 1"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
    datastore_id     = data.vsphere_datastore.datastore.id

  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  tags = [
    vsphere_tag.environment_test.id,
    vsphere_tag.owner_ramanjeet.id
  ]

  lifecycle {
    ignore_changes = [tags]
  }
}
