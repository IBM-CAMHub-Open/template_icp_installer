#
output "ibm_cloud_private_admin_url" {
  value = "https://${var.cluster_vip}:8443"
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

output "ibm_cloud_private_boot_ip" {
  value = "${element(values(var.boot_hostname_ip),0)}"
}
