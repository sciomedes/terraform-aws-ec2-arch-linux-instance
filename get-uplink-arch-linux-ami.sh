#!/usr/bin/env bash

#------------------------------------------------------------------------
# these sample usage commands are identical:
#   get-uplink-arch-linux-ami.sh -rdt s3 -k stable -r us-west-2
#   get-uplink-arch-linux-ami.sh --root-device-type s3 --kernel stable --region us-west-2
#------------------------------------------------------------------------

#------------------------------------------------------------------------
# default option values:
#------------------------------------------------------------------------
Region="us-east-1"    # us-east-2 | us-west-1 | us-west-2 | etc.
RootDeviceType="ebs"  # ebs or s3
Kernel="lts"          # lts or stable

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -r|--region)
    Region="$2"
    shift # past argument
    shift # past value
    ;;
    -rdt|--root-device-type)
    RootDeviceType="$2"
    shift # past argument
    shift # past value
    ;;
    -k|--kernel)
    Kernel="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


#------------------------------------------------------------------------
# harvest AMI from site:
#------------------------------------------------------------------------
site="https://www.uplinklabs.net/projects/arch-linux-on-ec2/"
page=$(curl -s "$site")
table=$(echo "$page" | grep -A4 -m1 "<th>${Region}</th>")

# table elements are in this order: ebs:lts, s3:lts, ebs:stable, s3:stable
case "$RootDeviceType:$Kernel" in

    "ebs:lts")
        td=$(echo "$table" | head -n2 | tail -n1)
    ;;

    "s3:lts")
        td=$(echo "$table" | head -n3 | tail -n1)
    ;;

    "ebs:stable")
        td=$(echo "$table" | head -n4 | tail -n1)
    ;;

    "s3:stable")
        td=$(echo "$table" | tail -n1)
    ;;

esac

#------------------------------------------------------------------------
# write ami to file:
#------------------------------------------------------------------------
ami_file=$(printf "arch-linux-%s-%s-%s.ami" "$RootDeviceType" "$Kernel" "$Region")
ami=$(echo $td | grep -Eo '>ami-[0-9a-f]+' | sed 's#>##')
echo $ami > ${ami_file}

#------------------------------------------------------------------------
# echo values to screen:
#------------------------------------------------------------------------
echo Region         = "${Region}"
echo RootDeviceType = "${RootDeviceType}"
echo Kernel         = "${Kernel}"
echo AMI            = "${ami}"
