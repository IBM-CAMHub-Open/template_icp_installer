resource "null_resource" "config_icp_boot_dependsOn" {
  provisioner "local-exec" {
    # Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
    command = "echo The dependsOn output for ICP Boot is ${var.dependsOn}"
  }
}

resource "null_resource" "setup_installer" {
  depends_on = ["null_resource.config_icp_boot_dependsOn"]

  count = "${length(var.vm_ipv4_address_list)}"

  connection {
    type        = "ssh"
    user        = "${var.vm_os_user}"
    password    = "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host        = "${var.vm_ipv4_address_list[count.index]}"
  }

  provisioner "file" {
    source      = "/tmp/${var.random}/icp_hosts"
    destination = "/root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/hosts"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"version: ${var.icp_version}\" >> /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "cat /root/glusterfs.txt >> /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "echo \"kibana_install: ${var.enable_kibana}\" >> /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "echo \"metering_enabled: ${var.enable_metering}\" >> /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",

      # "echo \"cluster_access_ip: ${var.cluster_access_ip}\" >> /root/${var.icp_version}/cluster/config.yaml",
      "sed -i 's/# cluster_vip.*/cluster_vip: ${var.cluster_vip}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",

      "sed -i 's/# vip_iface.*/vip_iface: ${var.cluster_vip_iface}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/# proxy_vip_iface.*/proxy_vip_iface: ${var.proxy_vip_iface}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/# proxy_vip.*/proxy_vip: ${var.proxy_vip}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/# cluster_name.*/cluster_name: ${var.icp_cluster_name}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/# cluster_CA_domain.*/cluster_CA_domain: ${var.icp_cluster_name}.${var.vm_domain}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/default_admin_user.*/default_admin_user: ${var.icp_admin_user}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "sed -i 's/default_admin_password.*/default_admin_password: ${var.icp_admin_password}/g' /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/config.yaml",
      "mkdir -p /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/cfc-certs/",
      "cd /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/cfc-certs/ && openssl req -x509 -nodes -sha256 -subj '/CN=${var.icp_cluster_name}.${var.vm_domain}' -days 36500 -newkey rsa:2048 -keyout icp-auth.key -out icp-auth.crt",
      "cp /root/.ssh/id_rsa /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster/ssh_key",
    ]
  }
}

resource "null_resource" "run_icp_installer" {
  depends_on = ["null_resource.setup_installer"]

  count = "${length(var.vm_ipv4_address_list)}"

  connection {
    type        = "ssh"
    user        = "${var.vm_os_user}"
    password    = "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host        = "${var.vm_ipv4_address_list[count.index]}"
  }

  provisioner "remote-exec" {
    inline = [
      "cd  /root/ibm-cloud-private-x86_64-${var.icp_version}/cluster",
      "sudo docker run --net=host -t -e LICENSE=accept  -v $(pwd):/installer/cluster ibmcom/icp-inception:${var.icp_version}-ee install | sudo tee -a /root/cfc-install.log",
      "docker run -e LICENSE=accept --net=host --rm -v /usr/local/bin:/data ibmcom/hyperkube::v${var.kub_version}-ee cp /kubectl /data",
    ]
  }
}

resource "null_resource" "icp_install_finished" {
  depends_on = ["null_resource.run_icp_installer"]

  provisioner "local-exec" {
    command = "echo 'ICP MultiNode has been installed.'"
  }
}
