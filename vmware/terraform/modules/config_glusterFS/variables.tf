variable "vm_ipv4_address_str"  { type = "string" description = "IPv4 Address's in String format"}
variable "vm_ipv4_address_list" { type = "list"   description = "IPv4 Address's in List format"}
variable "dependsOn"            { type = "string" default = "true" description = "Boolean for dependency" }
variable "enable_glusterFS"     { type = "string" description = "Enable GlusterFS on Worker nodes?"}
variable "random"               { type = "string" description = "Random String Generated"}
variable "vm_os_password"       { type = "string" description = "Operating System Password for the Operating System User to access virtual machine"}
variable "vm_os_user"           { type = "string" description = "Operating System user for the Operating System User to access virtual machine"}
variable "private_key"          { type = "string" description ="Private SSH key Details to the Virtual machine"}
variable "boot_vm_ipv4_address" { type = "string" description ="IPv4 Addressof the Management Node"}