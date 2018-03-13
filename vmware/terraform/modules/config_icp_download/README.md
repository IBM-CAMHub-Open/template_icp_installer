<!---
Copyright IBM Corp. 2018, 2018
--->

# Config ICP Download Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dependsOn | Boolean for dependency | string | `true` | no |
| docker_url | IBM Cloud Private Docker Download Location | string | - | yes |
| download_user | Repository User Name (Optional) | string | - | yes |
| download_user_password | Repository User Password (Optional) | string | - | yes |
| icp_url | IBM Cloud Private ICP Download Location (http|https|ftp|file) | string | - | yes |
| icp_version | Version of ICP to be Installed | string | - | yes |
| private_key | Private SSH key Details to the Virtual machine | string | - | yes |
| random | Random String Generated | string | - | yes |
| vm_ipv4_address_list | IPv4 Address's in List format | list | - | yes |
| vm_os_password | Operating System Password for the Operating System User to access virtual machine | string | - | yes |
| vm_os_user | Operating System user for the Operating System User to access virtual machine | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
