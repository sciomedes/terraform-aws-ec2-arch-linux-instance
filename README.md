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
For example, to get the latest s3-backed stable kernel version in `us-west-2`, the command is:
```
./get-uplink-arch-linux-ami.sh --root-device-type s3 --kernel stable --region us-west-2
```

The `OwnerId` for the AMI can be obtained from the AWS CLI:
```
region="us-west-2"
kernel="stable"
storage="s3"
./get-uplink-arch-linux-ami.sh --root-device-type "$storage" --kernel "$kernel" --region "$region"
ami=$(cat "arch-linux-${storage}-${kernel}-${region}.ami")
aws ec2 describe-images --image-ids "$ami" | jq '.Images[] | .OwnerId'
```
:warning: If you get an error similar to this,
```
An error occurred (InvalidAMIID.NotFound) when calling the DescribeImages operation: The image id '[ami-1234567890abcdef1]' does not exist
```
then you may need to adjust your AWS credentials file `~/.aws/config` to use the matching region, e.g.,
```
region = us-west-2
```

Alternatively, the AWS Console can be used to get the value for the required `owners` field used in the module
with these steps:
+ Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/
+ In the navigation pane, choose AMIs.
+ In the first dropdown (likely defaulted to 'Owned by me'), select Public images.
+ Enter ami id.
Owner and other fields should be directly viewable.
For `ami-05eec913d3df7d754` and perhaps all Uplink Labs Arch Linux builds, the owner is `093273469852`
and the AMI name is `arch-linux-hvm-2019.05.13.x86_64-s3`.
Again, the region must match; for example, in this case the region we're using is `US West Oregon`.


## Usage

```
module "ec2_arch_linux" {
}
```

[Uplink Labs]: https://www.uplinklabs.net/projects/arch-linux-on-ec2/
[1]: https://wiki.archlinux.org/index.php/Arch_Linux_AMIs_for_Amazon_Web_Services
