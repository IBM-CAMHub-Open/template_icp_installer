<!---
Copyright IBM Corp. 2018, 2018
--->

# Config ICP Hosts Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| boot_public_ips | Management Nodes IPv4 Address's in List format | string | - | yes |
| dependsOn | Boolean for dependency | string | `true` | no |
| master_public_ips | Master Nodes IPv4 Address's in List format | string | - | yes |
| proxy_public_ips | Proxy Nodes IPv4 Address's in List format | string | - | yes |
| random | Random String Generated | string | - | yes |
| va_public_ips | Vulnerability Nodes IPv4 Address's in List format | string | - | yes |
| worker_public_ips | Worker Nodes IPv4 Address's in List format | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| dependsOn | Output Parameter when Module Complete |
