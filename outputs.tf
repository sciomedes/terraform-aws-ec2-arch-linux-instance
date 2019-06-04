# EC2 instance public IP:
output "ip" {
  value = "${aws_instance.arch-linux-node.public_ip}"
}

# EC2 instance id:
output "instance-id" {
  value = "${aws_instance.arch-linux-node.id}"
}

# availability zone info:
output "az" {
  value = "${aws_instance.arch-linux-node.availability_zone}"
}

# root block device info:
output "root-device-volume" {
  value = "${aws_instance.arch-linux-node.root_block_device.0.volume_id}"
}
