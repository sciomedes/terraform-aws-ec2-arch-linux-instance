#!/usr/bin/env bash

#------------------------------------------------------------------------
# sync and update package:
#------------------------------------------------------------------------
echo "yes | pacman -Syuq"
yes | pacman -Syuq

#------------------------------------------------------------------------
# custom package installations:
#------------------------------------------------------------------------
declare -a pkglist=(
    "apg"
    "aws-cli"
    "bash-completion"
    "cmake"
    "colordiff"
    "dos2unix"
    "emacs-nox"
    "git"
    "go"
    "go-tools"
    "jq"
    "ntp"
    "pwgen"
    "screen"
    "screenfetch"
    "tree"
    "unzip"
    "xkcdpass"
    "zip"
)

for pkg in "${pkglist[@]}"
do
    echo "yes | pacman -S \"$pkg\""
    yes | pacman -S "$pkg"
done

#------------------------------------------------------------------------
# auxilliary actions:
#------------------------------------------------------------------------
# ntp:
systemctl --now enable ntpd

# bash-completion for aws cli:
complete -C aws_completer aws
echo \"complete -C `which aws_completer` aws\" >> ~/.bashrc
