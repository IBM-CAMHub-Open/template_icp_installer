resource "null_resource" "create_nfs_client_dependsOn" {
  provisioner "local-exec" {
    # Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
	  command = "echo The dependsOn output for nfs_client module is ${var.dependsOn}"
  }
}

resource "null_resource" "create_nfs_client" {
  count = "${length(var.vm_ipv4_address_list)}"
  depends_on = ["null_resource.create_nfs_client_dependsOn"]
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.vm_os_private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"

  }

  provisioner "file" {
    source = "${path.module}/scripts/connect_nfs.sh"
    destination = "/tmp/connect_nfs.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/connect_nfs.sh",
      "echo '/tmp/connect_nfs.sh $@' /tmp/connect_nfs.sh -s ${var.nfs_server} -f ${var.nfs_folder} -m ${var.nfs_mount_point} -l ${var.nfs_link_folders}",
      "bash -c '/tmp/connect_nfs.sh $@' /tmp/connect_nfs.sh -s ${var.nfs_server} -f ${var.nfs_folder} -m ${var.nfs_mount_point} -l ${var.nfs_link_folders}"
    ]
  }
}

resource "null_resource" "nfs_client_create" {
  depends_on = ["null_resource.create_nfs_client"]
  provisioner "local-exec" {
    command = "echo 'NFS client created'" #${var.vm_ipv4_address_list}.'"
  }
}
