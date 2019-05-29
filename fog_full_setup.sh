#!/bin/bash

# Script installs Fog clone image provisioner on Linux box
# Setup firewalld, dhcp, dns, tftp, mysql, and apache
# OPTIONAL - Pass proxy as parameter on position $1

# Uncomment below line to debug
# set -o xtrace

pushd /opt
FOG_RELEASE='1.5.6'
FOG_DOWNLOAD_URL='https://github.com/FOGProject/fogproject/archive'
DB_PASS='secure9'

# If proxy passed as parameter
[[ -n "$1" ]] && x="-x $1"

curl -OL https://github.com/dlux/InstallScripts/raw/master/common_functions $x
curl -OL https://github.com/dlux/InstallScripts/raw/master/common_packages $x
source common_packages

WriteLog "Installing and configuring FOG"
WriteLog "Proxy=$1"

[[ -n "$1" ]] && SetProxy "$1"

EnsureRoot
UpdatePackageManager

WriteLog "Install fog pre-req packages"
$_INSTALLER_CMD bc curl gcc gcc-c++ genisoimage gzip httpd lftp m4 make mtools
$_INSTALLER_CMD mod_ssl mysql mysql-server net-tools nfs-utils php php-cli
$_INSTALLER_CMD php-bcmath php-common php-fpm php-gd php-ldap php-process
$_INSTALLER_CMD php-mbstring php-mysqlnd syslinux tftp-server xinetd
$_INSTALLER_CMD unzip vsftpd wget xz-devel vim tar firewalld dhcp

WriteLog 'Setting up firewalld'
systemctl start firewalld
systemctl enable firewalld

for svr in http https tftp ftp mysql nfs mountd rpc-bind proxy-dhcp samba; do
    firewall-cmd --permanent --zone=public --add-service=$svr
done

WriteLog "Opening UDP port 49152 through 65532 in case of multicast"
firewall-cmd --permanent --add-port=49152-65532/udp
WriteLog "Allow IGMP traffic for multicast"
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p igmpi \
    -j ACCEPT
systemctl restart firewalld.service

for service in dhcp dns; do
    firewall-cmd --permanent --zone=public --add-service=$service
done
firewall-cmd --reload

WriteLog 'Set selinux as permissive'
sefile='/etc/selinux/config'
sed -i.bak 's/^.*\SELINUX=enforcing\b.*$/SELINUX=permissive/' $sefile
setenforce 0

WriteLog "Processing tarball to install fog $FOG_TAR_RELEASE.tar.gz"
curl -OL "$FOG_DOWNLOAD_URL/$FOG_RELEASE.tar.gz"
[[ ! -f "$FOG_RELEASE.tar.gz" ]] && PrintError "Unable to download tarball"
tar -xzvf $FOG_RELEASE.tar.gz
rm -f $FOG_RELEASE.tar.gz
pushd "fogproject-$FOG_RELEASE/bin"
#printf "N\n1\nN\nN\nN\nn\nn\nN\nN\nY\n" | ./installfog.sh
printf "N\n\n1\nN\nN\nN\nY\n\nY\n\ny\nN\nY\nY\n\n" | ./installfog.sh

