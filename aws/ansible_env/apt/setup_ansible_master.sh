#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No agent ip supplied"
    exit
fi

sudo apt-get update -y
sudo apt-get upgrade -y

sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update -y
sudo apt-get install ansible -y

# sudo apt-get install python -y 

agent_ip="${1}"

echo "[TEST]" >> /etc/ansible/hosts
echo "${agent_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/ansible_master" >> /etc/ansible/hosts

