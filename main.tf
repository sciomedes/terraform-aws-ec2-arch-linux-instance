#------------------------------------------------------------------------
# aws provider specifying region
#------------------------------------------------------------------------
provider "aws" {
  region = "${var.region}"
}

#------------------------------------------------------------------------
# local values:
#------------------------------------------------------------------------
locals {
  // construct path to local file containing private key:
  private_key_file = "${var.key_directory}/${var.key_name}"
}

#------------------------------------------------------------------------
# aws_instance.arch-linux-node
#------------------------------------------------------------------------
resource "aws_instance" "arch-linux-node" {

  # AMI, instance type, and private key used for access:
  ami             = "${var.ami_id}"
  instance_type   = "${var.instance_type}"
  key_name        = "${var.key_name}"

  # VPC and public IP settings:
  vpc_security_group_ids      = "${var.vpc_security_group_ids}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  subnet_id                   = "${var.subnet_id}"

  # allocate root block device:
  root_block_device {
    volume_size = "${var.root_volume_size}"
    delete_on_termination = true
  }

  # tag instance:
  tags = "${var.tags}"

  #--------------------------------------------
  # remote provisioning from file
  #--------------------------------------------
  # upload setup script to instance:
  provisioner "file" {
    source      = "${path.module}/setup.sh"
    destination = "/tmp/setup.sh"
  }

  # execute setup script:
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/setup.sh",
      "/tmp/setup.sh"
    ]
  }

  # connection settings for above file and remote-exec provisioner access
  connection {
    host        = "${self.public_ip}"
    type        = "ssh"
    user        = "${var.ec2_username}"
    private_key = "${file(local.private_key_file)}"
  }


  #--------------------------------------------
  # locally store instance info
  #--------------------------------------------
  provisioner "local-exec" {
    command = <<EOT
echo "${self.public_ip}" > public-ip.txt
echo "${aws_instance.arch-linux-node.id}" > instance-id.txt
echo "ssh -i ${local.private_key_file} ${var.sshopts} ${var.ec2_username}@${aws_instance.arch-linux-node.public_ip}" > connect
chmod u+x connect
   EOT

    on_failure = "continue"
  }

} // aws_instance.arch-linux-node
