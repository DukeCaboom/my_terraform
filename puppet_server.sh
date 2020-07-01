# puppet_agent_ip = 3.234.217.184
# puppet_master_ip = 54.145.237.184

sudo yum -y update
sudo yum -y install wget curl vim bash-completion
sudo hostnamectl set-hostname puppetmaster

echo "54.145.237.184 puppetmaster" | sudo tee -a /etc/hosts
sudo systemctl restart systemd-hostnamed

sudo yum -y install chrony
sudo systemctl enable --now chronyd
sudo timedatectl set-timezone America/New_York --adjust-system-clock
sudo timedatectl set-ntp yes

sudo yum -y install https://yum.puppet.com/puppet-release-el-8.noarch.rpm
sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sudo yum makecache

sudo yum -y install puppetserver

# /etc/puppetlabs/puppet/puppet.conf
# Add the DNS settings under the [master] section.
echo "dns_alt_names = puppetmaster puppet" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf

echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "certname = puppetmaster" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "server = puppetmaster" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "environment = production" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
echo "runinterval = 1h" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf

sudo systemctl enable --now puppetserver
sudo systemctl restart puppetserver

echo "export PATH=$PATH:/opt/puppetlabs/bin" | sudo tee -a ~/.bashrc
source ~/.bashrc