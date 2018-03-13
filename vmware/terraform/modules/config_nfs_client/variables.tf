variable "vm_os_password" {
  type = "string"
  description = "Password for the Operating System User to access virtual machine"
}
variable "vm_os_user" {
  type = "string"
  description = "User for the Operating System User to access virtual machine"
}
variable "vm_ipv4_address_list" {
  description = "IPv4 address for vNIC configuration"
  type = "list"
}
variable "dependsOn" {
  default = "true"
  description = "Boolean for dependency"
}
variable "vm_os_private_key" {
  default = ""
}

variable "nfs_server" {
  type = "string"
  description = "Address of the NFS server"
}
variable "nfs_folder" {
  type = "string"
  description = "Path on the NFS server to mount"
}
variable "nfs_mount_point" {
  type = "string"
  default = "/nfs"
  description = "Path on the client where the NFS server should be mounted"
}

variable "nfs_link_folders" {
  type = "string"
  default = "/var/lib/registry,/var/lib/icp/audit"
  description = "Directories to be mounted and dynamic linked to the NFS Share"
}
