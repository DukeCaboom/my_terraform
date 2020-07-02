#!/bin/bash

sudo yum -y update
sudo yum -y install wget curl vim bash-completion

sudo hostnamectl set-hostname puppet
sudo systemctl restart systemd-hostnamed

sudo yum -y install chrony
sudo systemctl enable --now chronyd
sudo timedatectl set-timezone America/New_York --adjust-system-clock
sudo timedatectl set-ntp yes

sudo yum -y install https://yum.puppet.com/puppet-release-el-8.noarch.rpm
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sudo yum makecache

sudo yum -y install puppetserver

# disable SELINUX

# echo "3.236.50.58 puppetagent" | sudo tee -a /etc/hosts
# echo "3.236.8.222 puppet" | sudo tee -a /etc/hosts


# # /etc/puppetlabs/puppet/puppet.conf
# # Add the DNS settings under the [master] section.

echo "dns_alt_names = puppet" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "certname = puppet" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "server = puppet" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "environment = production" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "runinterval = 1h" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf

sudo systemctl enable --now puppetserver
sudo systemctl start puppetserver

echo "export PATH=$PATH:/opt/puppetlabs/bin" | sudo tee -a ~/.bashrc
source ~/.bashrc