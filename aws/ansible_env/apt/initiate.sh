#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "No terraform plan provided"
    exit
fi

tf_plan=$1

ssh-keygen -f ~/.ssh/ansible_master -t rsa -b 4096 -N ''
terraform apply -auto-approve ${tf_plan}
rm -f ~/.ssh/ansible_master ~/.ssh/ansible_master.pub
