#!/bin/bash

# Script installs Fog clone image provisioner on Linux box
# No firewalld, no dhcp, or dns - just tftp, mysql, and apache
# OPTIONAL - Pass proxy as parameter on position $1

# Uncomment below line to debug
# set -o xtrace

pushd /opt
FOG_RELEASE="1.5.6"
FOG_DOWNLOAD_URL="https://github.com/FOGProject/fogproject/archive"

# If proxy passed as parameter
[[ -n "$1" ]] && x="-x $1"

curl -OL https://github.com/dlux/InstallScripts/raw/master/common_functions $x
curl -OL https://github.com/dlux/InstallScripts/raw/master/common_packages $x
source common_packages

WriteLog "Installing and configuring FOG"
WriteLog "Proxy=$1"

if [[ -n "$1" ]]; then
    SetProxy "$1"
    # Add private networks to no_proxy
    sed -i 's/no_proxy=/no_proxy=152.16.0.0\/24,20.20.0.0\/24,/g' .PROXY
    sed -i 's/NO_PROXY=/no_proxy=152.16.0.0\/24,20.20.0.0\/24,/g' .PROXY
    source .PROXY
fi

EnsureRoot
UpdatePackageManager

WriteLog "Install fog pre-req packages"
$_INSTALLER_CMD bc curl gcc gcc-c++ genisoimage gzip httpd lftp m4 make
$_INSTALLER_CMD mod_ssl mtools mysql mysql-server net-tools nfs-utils php
$_INSTALLER_CMD php-bcmath php-cli php-common php-fpm php-gd php-ldap tar
$_INSTALLER_CMD php-mbstring php-mysqlnd php-process syslinux tftp-server
$_INSTALLER_CMD unzip vsftpd wget xinetd xz-devel vim

WriteLog "Processing tarball to install fog $FOG_TAR_RELEASE.tar.gz"
curl -OL "$FOG_DOWNLOAD_URL/$FOG_RELEASE.tar.gz"
[[ ! -f "$FOG_RELEASE.tar.gz" ]] && PrintError "Unable to download tarball"
tar -xzvf $FOG_RELEASE.tar.gz
rm -f $FOG_RELEASE.tar.gz
pushd "fogproject-$FOG_RELEASE/bin"
printf "Y\n1\nN\nN\nN\nn\nn\nN\nN\nY\n" | ./installfog.sh

