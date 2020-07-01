# puppet_agent_ip = 3.234.217.184
# puppet_master_ip = 54.145.237.184

sudo yum -y update
sudo yum -y install wget curl vim bash-completion

sudo yum -y install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm
sudo yum -y install puppet-agent

echo "54.145.237.184 puppetmaster puppet" | sudo tee -a /etc/hosts

# /etc/puppetlabs/puppet/puppet.conf

echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "certname = puppetagent" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "server = puppetmaster" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "environment = production" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf


# puppet agent --test --ca_server=puppetmaster
