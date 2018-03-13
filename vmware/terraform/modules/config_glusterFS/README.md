<!---
Copyright IBM Corp. 2018, 2018
--->

# Config Gluster File System Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| boot_vm_ipv4_address | IPv4 Addressof the Management Node | string | - | yes |
| dependsOn | Boolean for dependency | string | `true` | no |
| enable_glusterFS | Enable GlusterFS on Worker nodes? | string | - | yes |
| private_key | Private SSH key Details to the Virtual machine | string | - | yes |
| random | Random String Generated | string | - | yes |
| vm_ipv4_address_list | IPv4 Address's in List format | list | - | yes |
| vm_ipv4_address_str | IPv4 Address's in String format | string | - | yes |
| vm_os_password | Operating System Password for the Operating System User to access virtual machine | string | - | yes |
| vm_os_user | Operating System user for the Operating System User to access virtual machine | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
