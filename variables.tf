variable "instance_type" {
  description = "EC2 instance type"
  default = "t2.nano"
}

variable "root_volume_size" {
  description = "Size in GB of root drive"
  default = 8
}

variable "associate_public_ip_address" {
  description = "Should pubilc IP be associated with instance"
  default = true
}

variable "ec2_username" {
  description = "EC2 instance user login"
  default = "root"
}

variable "ami_id" {
  description = "Id of AMI"
  default = ""
}

variable "region" {
  description = "AWS region in which AMI is located"
  default = ""
}

variable "key_name" {
  description = "Name of key already loaded into AWS region"
  default = ""
}

variable "key_directory" {
  description = "Name of directory where corresponding local key is stored"
  default = ""
}

variable "vpc_security_group_ids" {
  description = "VPC Security groups to have access to instance"
  type    = list(string)
  default = []
}

variable "subnet_id" {
  description = "Id of VPC subnet to use"
  default = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  default     = {}
  type        = "map"
}

variable "sshopts" {
  description = "SSH options used"
  default = "-o IdentitiesOnly=yes -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
}
