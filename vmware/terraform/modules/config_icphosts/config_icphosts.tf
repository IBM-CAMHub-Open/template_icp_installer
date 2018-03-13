resource "null_resource" "icp_hosts_files"{
  provisioner "local-exec" {
  //  command =  "echo '[master]' | tee -a /tmp/${var.random}/icp_hosts"
  command =  "echo Create ICP Host File"
  }
}

data "local_file" "example" {
  depends_on = ["null_resource.icp_hosts_files"]
  filename = "${path.module}/scripts/generate_icp_hosts.sh"
}

resource "local_file" "generate_icp_hosts_file" {
  depends_on = ["null_resource.icp_hosts_files"]
  content = "${data.local_file.example.content}"
  filename  = "/tmp/${var.random}/generate_icp_hosts.sh"
}

resource "null_resource" "generate_icp_hosts_file" {
  depends_on = ["local_file.generate_icp_hosts_file"]
  provisioner "local-exec" {
    command = "bash -c '/tmp/${var.random}/generate_icp_hosts.sh -r ${var.random} -m ${var.master_public_ips} -b ${var.boot_public_ips} -p ${var.proxy_public_ips} -w ${var.worker_public_ips} -v ${var.va_public_ips}'"
  }
}

resource "null_resource" "populate_icp_hosts_with_quotes"{
  depends_on = ["null_resource.generate_icp_hosts_file"]
  provisioner "local-exec" {
	command = "echo ICP HOST FILE GENERATED"
  }
}