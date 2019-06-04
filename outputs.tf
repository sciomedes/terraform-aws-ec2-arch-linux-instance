output "ip" {
  description = "EC2 instance public IP"
  value = "${aws_instance.arch-linux-node.public_ip}"
}

output "instance-id" {
  description = "EC2 instance id"
  value = "${aws_instance.arch-linux-node.id}"
}

output "az" {
  description = "availability zone info"
  value = "${aws_instance.arch-linux-node.availability_zone}"
}

output "root-device-volume" {
  description = "root block device info"
  value = "${aws_instance.arch-linux-node.root_block_device.0.volume_id}"
}
