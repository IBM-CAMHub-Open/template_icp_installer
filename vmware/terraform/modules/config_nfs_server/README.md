<!---
Copyright IBM Corp. 2018, 2018
--->

# Config NFS Server Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dependsOn | Boolean for dependency | string | `true` | no |
| nfs_drive | Drive that should be formatted and used as NFS | string | `/dev/sdb` | no |
| vm_ipv4_address_list | IPv4 address for vNIC configuration | list | - | yes |
| vm_os_password | Password for the Operating System User to access virtual machine | string | - | yes |
| vm_os_private_key |  | string | `` | no |
| vm_os_user | User for the Operating System User to access virtual machine | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
