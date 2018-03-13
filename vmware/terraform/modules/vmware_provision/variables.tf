
##############################################################
# Vsphere data for provider
##############################################################
data "vsphere_datacenter" "vsphere_datacenter" {
  name = "${var.vsphere_datacenter}"
}
data "vsphere_datastore" "vsphere_datastore" {
  name = "${var.vm_disk1_datastore}" 
  datacenter_id = "${data.vsphere_datacenter.vsphere_datacenter.id}"
}
data "vsphere_resource_pool" "vsphere_resource_pool" {
  name = "${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.vsphere_datacenter.id}"
}
data "vsphere_network" "vm_network" {
  name = "${var.vm_network_interface_label}"
  datacenter_id = "${data.vsphere_datacenter.vsphere_datacenter.id}"
}

data "vsphere_virtual_machine" "vm_template" {
  name = "${var.vm_template}"
  datacenter_id = "${data.vsphere_datacenter.vsphere_datacenter.id}"
}

#Variable : vm_-name
variable "vm_name" {
  type = "string"
}
variable "count" {
  type = "string"
  default = "1"
}

#########################################################
##### Resource : vm_
#########################################################

variable "vm_os_password" {
  type = "string"
  description = "Operating System Password for the Operating System User to access virtual machine"
}
variable "vm_os_user" {
  type = "string"
  description = "Operating System user for the Operating System User to access virtual machine"
  }

variable "vm_private_ssh_key" { }
variable "vm_public_ssh_key" { }

variable "vm_folder" {
  description = "Target vSphere folder for virtual machine"
}

variable "vm_template" {
  description = "Target vSphere folder for virtual machine"
}

variable "vsphere_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
}

variable "vm_domain" {
  description = "Domain Name of virtual machine"
}

variable "vm_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default = "1"
}

variable "vm_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default = "1024"
}

variable "vsphere_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "vm_dns_suffixes" {
  type = "list"
  description = "Name resolution suffixes for the virtual network adapter"
}

variable "vm_dns_servers" {
  type = "list"
  description = "DNS servers for the virtual network adapter"
}

variable "vm_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "vm_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
}

variable "vm_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
  type = "list"
}

variable "vm_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
}

variable "vm_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default = "vmxnet3"
}


variable "vm_disk1_size" {
  description = "Size of template disk volume"
}

variable "vm_disk1_keep_on_remove" {
  type = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default = "false"
}

variable "vm_disk1_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}


variable "vm_disk2_enable" {
  type = "string"
  description = "Enable a Second disk on VM"
} 

variable "vm_disk2_size" {
  description = "Size of template disk volume"
}

variable "vm_disk2_keep_on_remove" {
  type = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default = "false"
}

variable "vm_disk2_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}
variable "random" { type = "string" description = "Random String Generated"}

variable "dependsOn" {
  default = "true"
  description = "Boolean for dependency"
}