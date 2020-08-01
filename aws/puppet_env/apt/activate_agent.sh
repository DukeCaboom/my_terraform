#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "No puppet master ip supplied"
    exit
fi
puppet_master_ip=$1

env="agent"
hostname=`hostname`
apt-get update -y
apt-get upgrade -y
wget http://apt.puppetlabs.com/puppetlabs-trusty.deb
dpkg -i puppetlabs-release-trusty.deb
apt-get update -y

apt-get -y install puppet
sed -i "s/$hostname/$env/g" /etc/hostname

echo "${puppet_master_ip}  puppet.example.net    puppet" >>  /etc/hosts
echo "${puppet_master_ip}  puppet" >>  /etc/hosts

puppet agent --waitforcert 60
