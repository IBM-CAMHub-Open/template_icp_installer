resource "null_resource" "config_icp_download_dependsOn" {
  provisioner "local-exec" {
# Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
	  command = "echo The dependsOn output for Config ICP Download is ${var.dependsOn}"
  }
}

resource "null_resource" "mkdir-boot-node" {
  depends_on = ["null_resource.config_icp_download_dependsOn"]
  count = "${length(var.vm_ipv4_address_list)}"
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"
  
  }
    provisioner "remote-exec" {
    inline = [
      "mkdir -p /root/ibm-cloud-private-x86_64-${var.icp_version}"
    ]
  }
}


resource "null_resource" "install_docker" {
  depends_on = ["null_resource.mkdir-boot-node"]

  count = "${length(var.vm_ipv4_address_list)}"
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"
  
  }
  provisioner "file" {
    source = "${path.module}/scripts/docker_install.sh"
    destination = "/root/ibm-cloud-private-x86_64-${var.icp_version}/docker_install.sh"
  }
    
  provisioner "remote-exec" {
    inline = [
      "chmod 755 /root/ibm-cloud-private-x86_64-${var.icp_version}/docker_install.sh",
      "echo /root/ibm-cloud-private-x86_64-${var.icp_version}/docker_install.sh -d ${var.docker_url} -v ${var.icp_version} -u ${var.download_user} -p ${var.download_user_password}",
      "bash -c '/root/ibm-cloud-private-x86_64-${var.icp_version}/docker_install.sh -d ${var.docker_url} -v ${var.icp_version} -u ${var.download_user} -p ${var.download_user_password}'"
    ]
  }
}

resource "null_resource" "load_icp_images" {
  depends_on = ["null_resource.mkdir-boot-node"]

  count = "${length(var.vm_ipv4_address_list)}"
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"
  
  }
  
  provisioner "file" {
    source = "${path.module}/scripts/download_icp.sh"
    destination = "/root/ibm-cloud-private-x86_64-${var.icp_version}/download_icp.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "chmod 755 /root/ibm-cloud-private-x86_64-${var.icp_version}/download_icp.sh",
      "echo /root/ibm-cloud-private-x86_64-${var.icp_version}/download_icp.sh -i ${var.icp_url} -v ${var.icp_version} -u ${var.download_user} -p ${var.download_user_password}",
      "bash -c '/root/ibm-cloud-private-x86_64-${var.icp_version}/download_icp.sh -i ${var.icp_url} -v ${var.icp_version} -u ${var.download_user} -p ${var.download_user_password}'"
      # "tar -xf  ibm-cloud-private-x86_64-${var.ICP_Version}.tar.gz -O | sudo docker load",
      # "docker run -v $(pwd):/data -e LICENSE=accept ibmcom/icp-inception:${var.ICP_Version}-ee cp -r cluster /data",
      # "mkdir -p cluster/images; mv ibm-cloud-private-x86_64-${var.ICP_Version}.tar.gz cluster/images/"
    ]
  }
}

resource "null_resource" "docker_install_finished" {
  depends_on = ["null_resource.load_icp_images"]
  provisioner "local-exec" {
    command = "echo 'Docker and ICP Images loaded, has been installed on Nodes'"
  }
}
