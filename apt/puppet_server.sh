#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No hostname supplied"
    exit
fi
env=$1
echo $env
hostname=`hostname`
apt-get update -y
apt-get upgrade -y
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update -y
apt-get -y install puppetmaster
sed -i "s/$hostname/$env/g" /etc/hostname
sed -i "s/no/yes/g"  /etc/default/puppet-master
echo "127.0.0.1  puppet.example.net    puppet" >>  /etc/hosts
# TODO: dynamically fetch the IP address
echo "172.31.44.238  puppet.example.net    puppet" >>  /etc/hosts
reboot