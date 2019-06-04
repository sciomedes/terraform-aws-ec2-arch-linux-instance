# AWS EC2 Instance running Arch Linux module

## Prerequisites
At a minimum, you'll need to have [terraform](https://www.terraform.io) installed.
Some of the steps offered in this README file also use 
+ bash
+ [AWS Command Line Interface (CLI)](https://aws.amazon.com/cli/) and 
+ [jq JSON processor](https://stedolan.github.io/jq/).


## AMI source

This is a terraform module to launch an AWS EC2 instance running Arch Linux.
To accomplish this, we use AMIs found at [Uplink Labs].
New images are posted there approximately once per month and are available for a number of regions
and cover the following configurations:

+ ebs hvm x86_64 lts
+ s3 hvm x86_64 lts
+ ebs hvm x86_64 stable
+ s3 hvm x86_64 stable

For example, the 2019.05.13 release for instance running on root device type ebs with an LTS kernel is
+ [	ami-0e30953f18f5628a3](
https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#LaunchInstanceWizard:ami=ami-0e30953f18f5628a3)

A script for harvesting the latest release AMI is provided in 
[get-uplink-arch-linux-ami.sh](get-uplink-arch-linux-ami.sh).

Usage for this script is
```
./get-uplink-arch-linux-ami.sh --root-device-type <s3 | ebs> --kernel <lts | stable> --region <REGION>
```
For example, to get the latest ebs-backed lts kernel version in `us-west-2`, the command is:
```
./get-uplink-arch-linux-ami.sh --root-device-type ebs --kernel lts --region us-west-2
```
This should output to the following information to the screen:
```
Region = us-west-2
RootDeviceType = ebs
Kernel = lts
AMI = ami-09afa8e5aec9f9aa4
```
Also, the AMI id should be saved to the file `arch-linux-ebs-lts-us-west-2.ami`.


## Usage

```
module "ec2_arch_linux" {
  source = "git::https://github.com/sciomedes/terraform-aws-ec2-arch-linux-instance.git"

  #------------------------------------------------------------------------
  # instance details:
  #------------------------------------------------------------------------
  instance_type               = "t2.nano"   # AWS EC2 instance type
  root_volume_size            = 8           # size of root volume in GB
  associate_public_ip_address = true        # allocate a public IP
  ec2_username                = "root"      # instance user name


  #------------------------------------------------------------------------
  # the following settings are region-specific
  #------------------------------------------------------------------------
  # ami details:
  ami_id = "ami-09afa8e5aec9f9aa4"
  region = "us-west-2"

  # private key used to connect to instance:
  key_name       = "mykey"                   # name of key already uploaded to AWS region
  key_directory  = "/home/username/.ssh/"    # local directory where corresponding key is stored

  # up to five security groups are allowed for VPC:
  vpc_security_group_ids      = ["sg-96b99dv0d5174baf1"]
  subnet_id                   = "subnet-476b6vb6b24466301"


  #------------------------------------------------------------------------
  # tag resource:
  #------------------------------------------------------------------------
  tags = {
    SomeTag   = "Arch Linux"
    Terraform = "true"
  }
  #------------------------------------------------------------------------

}
```

[Uplink Labs]: https://www.uplinklabs.net/projects/arch-linux-on-ec2/
[1]: https://wiki.archlinux.org/index.php/Arch_Linux_AMIs_for_Amazon_Web_Services
