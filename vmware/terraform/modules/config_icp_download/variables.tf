variable "vm_os_password"       { type = "string"  description = "Operating System Password for the Operating System User to access virtual machine"}
variable "vm_os_user"           { type = "string"  description = "Operating System user for the Operating System User to access virtual machine"}
variable "vm_ipv4_address_list" { type="list"      description = "IPv4 Address's in List format"}
variable "private_key"          { type = "string"  description = "Private SSH key Details to the Virtual machine"}
variable "random"               { type = "string"  description = "Random String Generated"}
variable "dependsOn"            { default = "true" description = "Boolean for dependency"}
variable "docker_url"           { type = "string"  description = "IBM Cloud Private Docker Download Location"}
variable "icp_url"              { type = "string"  description = "IBM Cloud Private ICP Download Location (http|https|ftp|file)"}
variable "icp_version"          { type = "string"  description = "Version of ICP to be Installed"}
variable "download_user"        { type = "string"  description = "Repository User Name (Optional)" }    
variable "download_user_password"  { type = "string" description = "Repository User Password (Optional)"}  
    
