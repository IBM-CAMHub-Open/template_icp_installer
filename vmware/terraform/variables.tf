#Boot Node
variable "boot_hostname_ip" {
  type = "map"
}

variable "boot_vcpu" {
  type    = "string"
  default = "4"
}

variable "boot_memory" {
  type    = "string"
  default = "8192"
}

variable "boot_vm_ipv4_gateway" {
  type = "string"
}

variable "boot_vm_ipv4_prefix_length" {
  type = "string"
}

variable "boot_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "boot_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "boot_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "boot_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "boot_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "vm_clone_timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
  default = "30"
}

# Master Nodes
variable "master_hostname_ip" {
  type = "map"
}

variable "master_vcpu" {
  type    = "string"
  default = "8"
}

variable "master_memory" {
  type    = "string"
  default = "16384"
}

variable "master_vm_ipv4_gateway" {
  type = "string"
}

variable "master_vm_ipv4_prefix_length" {
  type = "string"
}

variable "master_vm_disk1_size" {
  type    = "string"
  default = "200"
}

variable "master_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "master_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "master_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "master_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "master_nfs_folders" {
  type    = "list"
  default = ["/var/lib/registry", "/var/lib/icp/audit"]
}

# Proxy Nodes
variable "proxy_hostname_ip" {
  type = "map"
}

variable "proxy_vcpu" {
  type    = "string"
  default = "2"
}

variable "proxy_memory" {
  type    = "string"
  default = "8192"
}

variable "proxy_vm_ipv4_gateway" {
  type = "string"
}

variable "proxy_vm_ipv4_prefix_length" {
  type = "string"
}

variable "proxy_vm_disk1_size" {
  type    = "string"
  default = "100"
}

variable "proxy_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "proxy_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "proxy_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "proxy_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

# Workers Nodes
variable "worker_hostname_ip" {
  type = "map"
}

variable "worker_vcpu" {
  type    = "string"
  default = "16"
}

variable "worker_memory" {
  type = "string"

  default = "32768"
}

variable "worker_vm_ipv4_gateway" {
  type = "string"
}

variable "worker_vm_ipv4_prefix_length" {
  type = "string"
}

variable "worker_vm_disk1_size" {
  type = "string"

  default = "200"
}

variable "worker_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "worker_vm_disk2_enable" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_size" {
  type = "string"

  default = "85"
}

variable "worker_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "worker_enable_glusterFS" {
  type    = "string"
  default = "true"
}

variable "gluster_volumetype_none" {
  type        = "string"
  default     = "false"
  description = "Gluster durability"
}

#VA Node
variable "va_hostname_ip" {
  type = "map"
}

variable "va_vcpu" {
  type    = "string"
  default = "4"
}

variable "va_memory" {
  type    = "string"
  default = "8192"
}

variable "va_vm_ipv4_gateway" {
  type = "string"
}

variable "va_vm_ipv4_prefix_length" {
  type = "string"
}

variable "va_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "va_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "va_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "va_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "va_vm_disk2_keep_on_remove" {
  type = "string"

  default = "false"
}

variable "enable_vm_va" {
  type = "string"

  default = "false"
}

#Management Node
variable "manage_hostname_ip" {
  type = "map"
}

variable "manage_vcpu" {
  type = "string"

  default = "8"
}

variable "manage_memory" {
  type = "string"

  default = "8192"
}

variable "manage_vm_ipv4_gateway" {
  type = "string"
}

variable "manage_vm_ipv4_prefix_length" {
  type = "string"
}

variable "manage_vm_disk1_size" {
  type = "string"

  default = "150"
}

variable "manage_vm_disk1_keep_on_remove" {
  type = "string"

  default = "false"
}

variable "manage_vm_disk2_enable" {
  type = "string"

  default = "false"
}

variable "manage_vm_disk2_size" {
  type = "string"

  default = "50"
}

variable "manage_vm_disk2_keep_on_remove" {
  type = "string"

  default = "false"
}

variable "enable_vm_management" {
  type = "string"

  default = "true"
}

variable "enable_nfs" {
  type    = "string"
  default = "false"
}

#NFS Server
variable "nfs_server_hostname_ip" {
  type = "map"
}

variable "nfs_server_vcpu" {
  type = "string"

  default = "4"
}

variable "nfs_server_memory" {
  type    = "string"
  default = "8192"
}

variable "nfs_server_vm_ipv4_gateway" {
  type = "string"
}

variable "nfs_server_vm_ipv4_prefix_length" {
  type = "string"
}

variable "nfs_server_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "nfs_server_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "nfs_server_vm_disk2_size" {
  type    = "string"
  default = "100"
}

variable "nfs_server_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "nfs_server_folder" {
  type    = "string"
  default = "/var/nfs"
}

# VM Generic Items
variable "vm_domain" {
  type = "string"
}

variable "vm_network_interface_label" {
  type = "string"
}

variable "vm_adapter_type" {
  type    = "string"
  default = "vmxnet3"
}

variable "vm_folder" {
  type = "string"
}

variable "vm_dns_servers" {
  type = "list"
}

variable "vm_dns_suffixes" {
  type = "list"
}

variable "vsphere_datacenter" {
  type = "string"
}

variable "vsphere_resource_pool" {
  type = "string"
}

variable "vm_template" {
  type = "string"
}

variable "vm_os_user" {
  type = "string"
}

variable "vm_os_password" {
  type = "string"
}

variable "vm_disk1_datastore" {
  type = "string"
}

variable "vm_disk2_datastore" {
  type = "string"
}

# SSH KEY Information
variable "icp_private_ssh_key" {
  type = "string"

  default = ""
}

variable "icp_public_ssh_key" {
  type = "string"

  default = ""
}

# Binary Download Locations
variable "docker_binary_url" {
  type = "string"
}

variable "icp_binary_url" {
  type = "string"
}

variable "icp_version" {
  type = "string"

  default = "2.1.0.3"
}

variable "kub_version" {
  type = "string"

  default = "1.10.0"
}

variable "icp_cluster_name" {
  type = "string"
}

# ICP Settings
variable "enable_bluemix_install" {
  type    = "string"
  default = "false"
}

variable "bluemix_token" {
  type    = "string"
  default = ""
}

variable "enable_kibana" {
  type = "string"

  default = "true"
}

variable "enable_metering" {
  type = "string"
  default = "true"
}

variable "enable_monitoring" {
  type    = "string"
  default = "true"
}

variable "icp_admin_user" {
  type = "string"

  default = "admin"
}

variable "icp_admin_password" {
  type = "string"

  default = "admin"
}

variable "download_user" {
  type = "string"
}

variable "download_user_password" {
  type = "string"
}

variable "cluster_vip" {
  type = "string"
}

variable "cluster_vip_iface" {
  type    = "string"
  default = "ens160"
}

variable "proxy_vip" {
  type = "string"
}

variable "proxy_vip_iface" {
  type = "string"
  default = "ens160"
}

variable "cluster_lb_address" {
  type = "string"
  default = "none"
  description = "IP Address of the Cluster Load Balancer"
}

variable "proxy_lb_address" {
  type = "string"
  default = "none"
  description = "IP Address of the Proxy Load Balancer"
}
