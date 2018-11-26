provider "openstack" {
  version  = "~> 1.8"
  insecure = true
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "deployVM_boot" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.boot_vm_ipv4_address)}"
  count = "${length(keys(var.boot_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.boot_hostname_ip)}"
  vm_flavor_id                      = "${var.boot_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.boot_hostname_ip)}"
  vm_disk1_size                     = "${var.boot_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.boot_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.boot_vm_disk2_enable}"
  vm_disk2_size                     = "${var.boot_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.boot_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "add_ilmt_file_boot" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${concat(values(var.boot_hostname_ip))}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
}

module "deployVM_master" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.master_vm_ipv4_address)}"
  count = "${length(keys(var.master_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.master_hostname_ip)}"
  vm_flavor_id                      = "${var.master_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.master_hostname_ip)}"
  vm_disk1_size                     = "${var.master_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.master_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.master_vm_disk2_enable}"
  vm_disk2_size                     = "${var.master_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.master_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "add_ilmt_file_master" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${concat(values(var.master_hostname_ip))}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
  dependsOn            = "${module.deployVM_master.dependsOn}"
}

module "deployVM_manage" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.master_vm_ipv4_address)}"
  count = "${length(keys(var.manage_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.manage_hostname_ip)}"
  vm_flavor_id                      = "${var.manage_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.manage_hostname_ip)}"
  vm_disk1_size                     = "${var.manage_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.manage_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.manage_vm_disk2_enable}"
  vm_disk2_size                     = "${var.manage_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.manage_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"
  enable_vm                         = "${var.enable_vm_management}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "deployVM_proxy" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.proxy_vm_ipv4_address)}"
  count = "${length(keys(var.proxy_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.proxy_hostname_ip)}"
  vm_flavor_id                      = "${var.proxy_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.proxy_hostname_ip)}"
  vm_disk1_size                     = "${var.proxy_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.proxy_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.proxy_vm_disk2_enable}"
  vm_disk2_size                     = "${var.proxy_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.proxy_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "add_ilmt_file_proxy" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${concat(values(var.proxy_hostname_ip))}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
  dependsOn            = "${module.deployVM_proxy.dependsOn}"
}

module "deployVM_worker" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.worker_vm_ipv4_address)}"
  count = "${length(keys(var.worker_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.worker_hostname_ip)}"
  vm_flavor_id                      = "${var.worker_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.worker_hostname_ip)}"
  vm_disk1_size                     = "${var.worker_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.worker_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.worker_enable_glusterFS && var.worker_vm_disk2_enable}"
  vm_disk2_size                     = "${var.worker_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.worker_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "add_ilmt_file_worker" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${concat(values(var.worker_hostname_ip))}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
  dependsOn            = "${module.deployVM_worker.dependsOn}"
}

module "deployVM_VA_Server" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.va_vm_ipv4_address)}"
  count = "${length(keys(var.va_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.va_hostname_ip)}"
  vm_flavor_id                      = "${var.va_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.va_hostname_ip)}"
  vm_disk1_size                     = "${var.va_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.va_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.va_vm_disk2_enable}"
  vm_disk2_size                     = "${var.va_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.va_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"
  enable_vm                         = "${var.enable_vm_va}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "deployVM_NFS_Server" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  # count                 = "${length(var.nfs_server_vm_ipv4_address)}"
  count = "${length(keys(var.nfs_server_hostname_ip))}"

  #######
  vm_name                           = "${keys(var.nfs_server_hostname_ip)}"
  vm_flavor_id                      = "${var.nfs_server_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.nfs_server_hostname_ip)}"
  vm_disk1_size                     = "${var.nfs_server_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.nfs_server_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.nfs_server_vm_disk2_size > 0 ? "true" : "false"}"
  vm_disk2_size                     = "${var.nfs_server_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.nfs_server_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"
  enable_vm                         = "${var.enable_nfs}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "icphosts" {
  source                = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_icphosts"
  master_public_ips     = "${join(",", values(var.master_hostname_ip))}"
  management_public_ips = "${join(",", values(var.manage_hostname_ip))}"
  proxy_public_ips      = "${join(",", values(var.proxy_hostname_ip))}"
  worker_public_ips     = "${join(",", values(var.worker_hostname_ip))}"
  va_public_ips         = "${join(",", values(var.va_hostname_ip))}"
  enable_vm_management  = "${var.enable_vm_management}"
  enable_vm_va          = "${var.enable_vm_va}"
  enable_glusterFS      = "${var.worker_enable_glusterFS}"
  random                = "${random_string.random-dir.result}"
  icp_version           = "${var.icp_version}"
}

module "icp_prereqs" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_icp_prereqs"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  vm_ipv4_address_list = "${compact(split(",", replace(join(",",concat(values(var.boot_hostname_ip), values(var.master_hostname_ip), values(var.proxy_hostname_ip), values(var.manage_hostname_ip), values(var.worker_hostname_ip), values(var.manage_hostname_ip), values(var.va_hostname_ip))),"/0.0.0.0/", "" )))}"

  random    = "${random_string.random-dir.result}"
  dependsOn = "${module.deployVM_VA_Server.dependsOn}+${module.deployVM_NFS_Server.dependsOn}+${module.deployVM_manage.dependsOn}+${module.deployVM_boot.dependsOn}+${module.deployVM_master.dependsOn}+${module.deployVM_proxy.dependsOn}+${module.deployVM_worker.dependsOn}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "push_hostfile" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_hostfile"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  # vm_ipv4_address_list = "${compact(concat(values(var.boot_hostname_ip), values(var.master_hostname_ip), values(var.proxy_hostname_ip), values(var.manage_hostname_ip), values(var.worker_hostname_ip), values(var.nfs_server_hostname_ip), values(var.va_hostname_ip)))}"
  vm_ipv4_address_list = "${compact(split(",", replace(join(",",concat(values(var.boot_hostname_ip), values(var.master_hostname_ip), values(var.proxy_hostname_ip), values(var.manage_hostname_ip), values(var.worker_hostname_ip), values(var.manage_hostname_ip), values(var.va_hostname_ip))),"/0.0.0.0/", "" )))}"
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.icp_prereqs.dependsOn}"

  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
}

module "add_ilmt_file_VA_Server" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  enable_vm               = "${var.enable_vm_va}"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${values(var.va_hostname_ip)}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######      
  dependsOn            = "${module.deployVM_VA_Server.dependsOn}"
}

module "add_ilmt_file_NFS_Server" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  enable_vm           = "${var.enable_nfs}"
  
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${values(var.nfs_server_hostname_ip)}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
  dependsOn            = "${module.push_hostfile.dependsOn}"
}

module "add_ilmt_file_manage" {
  source               = "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//config_add_ilmt_file"

  enable_vm               = "${var.enable_vm_management}"

  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_password       = "${var.vm_os_password}"
  vm_os_user           = "${var.vm_os_user}"
  vm_ipv4_address_list = "${values(var.manage_hostname_ip)}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}"
  #######    
  dependsOn            = "${module.push_hostfile.dependsOn}"
}

module "NFSServer-Setup" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_nfs_server"
  vm_ipv4_address_list = "${values(var.nfs_server_hostname_ip)}"
  vm_os_private_key    = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  nfs_drive            = "/dev/sdb"
  nfs_link_folders     = "${join(",", var.master_nfs_folders)}"
  enable_nfs           = "${var.enable_nfs}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
  dependsOn            = "${module.push_hostfile.dependsOn}"
}

module "NFSClient-Setup" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_nfs_client"
  vm_ipv4_address_list = "${values(var.master_hostname_ip)}"
  vm_os_private_key    = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  nfs_server           = "${values(var.nfs_server_hostname_ip)}"
  nfs_folder           = "${var.nfs_server_folder}"
  nfs_link_folders     = "${join(",", var.master_nfs_folders)}"
  enable_nfs           = "${var.enable_nfs}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
  dependsOn            = "${module.NFSServer-Setup.dependsOn}"
}

module "glusterFS" {
  source                  = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_glusterFS"
  vm_ipv4_address_list    = "${values(var.worker_hostname_ip)}"
  vm_ipv4_address_str     = "${join(" ", values(var.worker_hostname_ip))}"
  enable_glusterFS        = "${var.worker_enable_glusterFS}"
  random                  = "${random_string.random-dir.result}"
  private_key             = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user              = "${var.vm_os_user}"
  vm_os_password          = "${var.vm_os_password}"
  boot_vm_ipv4_address    = "${element(values(var.boot_hostname_ip),0)}"
  gluster_volumetype_none = "${var.gluster_volumetype_none}"
  icp_version             = "${var.icp_version}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
  dependsOn               = "${module.NFSClient-Setup.dependsOn}"
}

module "icp_download_load" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_icp_download"
  private_key             = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user              = "${var.vm_os_user}"
  vm_os_password          = "${var.vm_os_password}"
  vm_ipv4_address_list    = "${values(var.boot_hostname_ip)}"
  docker_url              = "${var.docker_binary_url}"
  icp_url                 = "${var.icp_binary_url}"
  icp_version             = "${var.icp_version}"
  download_user           = "${var.download_user}"
  download_user_password  = "${var.download_user_password}"
  enable_bluemix_install  = "${var.enable_bluemix_install}"
  random                  = "${random_string.random-dir.result}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
  dependsOn              = "${module.glusterFS.dependsOn}"
}

module "icp_config_yaml" {
  source                 = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_icp_boot_ha"
  private_key            = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${base64decode(var.icp_private_ssh_key)}"}"
  vm_os_user             = "${var.vm_os_user}"
  vm_os_password         = "${var.vm_os_password}"
  vm_ipv4_address_list   = "${values(var.boot_hostname_ip)}"
  enable_kibana          = "${lower(var.enable_kibana)}"
  enable_metering        = "${lower(var.enable_metering)}"
  enable_monitoring      = "${lower(var.enable_monitoring)}"  
  enable_va              = "${lower(var.enable_vm_va)}"
  cluster_vip            = "${var.cluster_vip}"
  cluster_vip_iface      = "${var.cluster_vip_iface}"
  cluster_lb_address     = "${var.cluster_lb_address}"
  proxy_lb_address       = "${var.proxy_lb_address}"
  proxy_vip              = "${var.proxy_vip}"
  proxy_vip_iface        = "${var.proxy_vip_iface}"
  icp_version            = "${var.icp_version}"
  kub_version            = "${var.kub_version}"
  vm_domain              = "${var.vm_domain}"
  icp_cluster_name       = "${var.icp_cluster_name}"
  icp_admin_user         = "${var.icp_admin_user}"
  icp_admin_password     = "${var.icp_admin_password}"
  enable_bluemix_install = "${var.enable_bluemix_install}"
  enable_glusterFS       = "${var.worker_enable_glusterFS}"
  bluemix_token          = "${var.bluemix_token}"
  random                 = "${random_string.random-dir.result}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_host_key    = "${var.bastion_host_key}"
  bastion_password    = "${var.bastion_password}" 
  dependsOn              = "${module.icp_download_load.dependsOn}+${module.icp_prereqs.dependsOn}+${module.push_hostfile.dependsOn}+${module.glusterFS.dependsOn}"
}
