<!---
Copyright IBM Corp. 2018, 2018
--->

# Config NFS Client Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dependsOn | Boolean for dependency | string | `true` | no |
| nfs_folder | Path on the NFS server to mount | string | - | yes |
| nfs_link_folders | Directories to be mounted and dynamic linked to the NFS Share | string | `/var/lib/registry,/var/lib/icp/audit` | no |
| nfs_mount_point | Path on the client where the NFS server should be mounted | string | `/nfs` | no |
| nfs_server | Address of the NFS server | string | - | yes |
| vm_ipv4_address_list | IPv4 address for vNIC configuration | list | - | yes |
| vm_os_password | Password for the Operating System User to access virtual machine | string | - | yes |
| vm_os_private_key |  | string | `` | no |
| vm_os_user | User for the Operating System User to access virtual machine | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
