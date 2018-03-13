variable "master_public_ips" { type = "string"  description = "Master Nodes IPv4 Address's in List format"}
variable "boot_public_ips"   { type = "string"  description = "Management Nodes IPv4 Address's in List format"}
variable "proxy_public_ips"  { type = "string"  description = "Proxy Nodes IPv4 Address's in List format"}
variable "worker_public_ips" { type = "string"  description = "Worker Nodes IPv4 Address's in List format"}
variable "va_public_ips"     { type = "string"  description = "Vulnerability Nodes IPv4 Address's in List format"}
variable "dependsOn"         { default = "true" description = "Boolean for dependency"}
variable "random"             { type = "string" description = "Random String Generated"}

