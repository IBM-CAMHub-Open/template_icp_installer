resource "null_resource" "create_nfs_server_dependsOn" {
  provisioner "local-exec" {
    # Hack to force dependencies to work correctly. Must use the dependsOn var somewhere in the code for dependencies to work. Contain value which comes from previous module.
	  command = "echo The dependsOn output for nfs server module is ${var.dependsOn}"
  }
}

resource "null_resource" "create_nfs_server" {
  count = "${length(var.vm_ipv4_address_list)}"
  depends_on = ["null_resource.create_nfs_server_dependsOn"]
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.vm_os_private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"

  }

  provisioner "file" {
    source = "${path.module}/scripts/setup_nfs.sh"
    destination = "/tmp/setup_nfs.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup_nfs.sh",
      "bash -c '/tmp/setup_nfs.sh $@' /tmp/setup_nfs.sh ${var.nfs_drive}"
    ]
  }
}

resource "null_resource" "nfs_server_create" {
  depends_on = ["null_resource.create_nfs_server"]
  provisioner "local-exec" {
    command = "echo 'NFS server created'" 
  }
}
