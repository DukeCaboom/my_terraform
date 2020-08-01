#!/bin/bash
env="puppet"
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
ipv4=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
echo "${ipv4}  puppet.example.net    puppet" >>  /etc/hosts
