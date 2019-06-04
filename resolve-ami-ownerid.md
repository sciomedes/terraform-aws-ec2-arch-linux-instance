# How to resolve the owner id for an existing AMI

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
