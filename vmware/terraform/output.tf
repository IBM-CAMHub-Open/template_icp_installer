#
output "ibm_cloud_private_admin_url" {
  value = "<a href='https://${var.cluster_vip}:8443' target='_blank'>https://${var.cluster_vip}:8443</a>"
}

output "ibm_cloud_private_admin_user" {
  value = "${var.icp_admin_user}"
}

output "ibm_cloud_private_admin_password" {
  value = "${var.icp_admin_password}"
}


output "ibm_cloud_private_master_ip" {
  value = "${var.cluster_vip}"
}
