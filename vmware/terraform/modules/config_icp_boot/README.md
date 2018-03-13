<!---
Copyright IBM Corp. 2018, 2018
--->

# Config ICP Management Node Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_vip | IBM Cloud Private Cluster Name | string | - | yes |
| cluster_vip_iface | IBM Cloud Private Cluster Network Interface | string | - | yes |
| dependsOn | Boolean for dependency | string | `true` | no |
| enable_kibana | Enable IBM Cloud Private Kibana | string | - | yes |
| enable_metering | Enable IBM Cloud Private Metering | string | - | yes |
| icp_admin_password | IBM Cloud Private Admin Password | string | - | yes |
| icp_admin_user | IBM Cloud Private Admin Username | string | - | yes |
| icp_cluster_name | IBM Cloud Private Cluster Name | string | - | yes |
| icp_version | IBM Cloud Private Version | string | - | yes |
| kub_version | Kubernetes Version | string | - | yes |
| private_key | Private SSH key Details to the Virtual machine | string | - | yes |
| proxy_vip | IBM Cloud Private Proxy VIP | string | - | yes |
| proxy_vip_iface | IBM Cloud Private Proxy Network Interface | string | - | yes |
| random | Random String Generated | string | - | yes |
| vm_domain | IBM Cloud Private Domain Name | string | - | yes |
| vm_ipv4_address_list | IPv4 Address's in List format | list | - | yes |
| vm_os_password | Operating System Password for the Operating System User to access virtual machine | string | - | yes |
| vm_os_user | Operating System user for the Operating System User to access virtual machine | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
