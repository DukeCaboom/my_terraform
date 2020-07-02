#!/bin/bash

sudo yum -y update
sudo yum -y install wget curl vim bash-completion

sudo hostnamectl set-hostname puppetagent
sudo systemctl restart systemd-hostnamed

sudo yum -y install https://yum.puppetlabs.com/puppet-release-el-7.noarch.rpm
sudo yum -y install puppet-agent

# echo "54.145.237.184 puppet" | sudo tee -a /etc/hosts

# # /etc/puppetlabs/puppet/puppet.conf

echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "certname = puppetagent" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "server = puppet" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "environment = production" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf

puppet agent --test --ca_server=puppetmaster




# instance_ip=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
# && curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/
