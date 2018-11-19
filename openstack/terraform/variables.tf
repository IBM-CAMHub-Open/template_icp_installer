#Boot Node
variable "boot_hostname_ip" {
  type = "map"
}

variable "boot_vm_flavor_id" {
  type    = "string"
}

variable "boot_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "boot_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "boot_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "boot_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "boot_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

# Master Nodes
variable "master_hostname_ip" {
  type = "map"
}

variable "master_vm_flavor_id" {
  type    = "string"
}

variable "master_vm_disk1_size" {
  type    = "string"
  default = "200"
}

variable "master_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "master_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "master_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "master_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "master_nfs_folders" {
  type    = "list"
  default = ["/var/lib/registry", "/var/lib/icp/audit"]
}

# Proxy Nodes
variable "proxy_hostname_ip" {
  type = "map"
}

variable "proxy_vm_flavor_id" {
  type    = "string"
}

variable "proxy_vm_disk1_size" {
  type    = "string"
  default = "100"
}

variable "proxy_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "proxy_vm_disk2_enable" {
  type    = "string"
  default = "false"
}

variable "proxy_vm_disk2_size" {
  type    = "string"
  default = "50"
}

variable "proxy_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

# Workers Nodes
variable "worker_hostname_ip" {
  type = "map"
}

variable "worker_vm_flavor_id" {
  type    = "string"
}

variable "worker_vm_disk1_size" {
  type = "string"
  default = "200"
}

variable "worker_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_enable" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_size" {
  type = "string"
  default = "85"
}

variable "worker_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
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

variable "va_vm_flavor_id" {
  type    = "string"
  default = ""
}

variable "va_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "va_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "va_vm_disk2_enable" {
  type = "string"
  default = "false"
}

variable "va_vm_disk2_size" {
  type = "string"
  default = "50"
}

variable "va_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "enable_vm_va" {
  type = "string"
  default = "false"
}

#Management Node
variable "manage_hostname_ip" {
  type = "map"
}

variable "manage_vm_flavor_id" {
  type    = "string"
  default = ""
}

variable "manage_vm_disk1_size" {
  type = "string"
  default = "150"
}

variable "manage_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "manage_vm_disk2_enable" {
  type = "string"
  default = "false"
}

variable "manage_vm_disk2_size" {
  type = "string"
  default = "50"
}

variable "manage_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
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

variable "nfs_server_flavor_id" {
  type    = "string"
  default = ""
}

variable "nfs_server_vm_disk1_size" {
  type    = "string"
  default = "150"
}

variable "nfs_server_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "nfs_server_vm_disk2_size" {
  type    = "string"
  default = "100"
}

variable "nfs_server_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "nfs_server_folder" {
  type    = "string"
  default = "/var/nfs"
}

# VM Generic Items
variable "vm_domain" {
  type = "string"
}

variable "vm_os_user" {
  type = "string"
}

variable "vm_os_password" {
  type = "string"
}

variable "vm_image_id" {
  type = "string"
}

variable "vm_public_ip_pool" {
  type = "string"
}

variable "vm_security_groups" {
  type = "list"
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
