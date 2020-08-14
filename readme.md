#### Ansible Environment in AWS

- Code location: ./aws/ansible_env

- To spin up one Ansible master and agent instances, execute steps
    
    ```
    ~$ terraform plan -out plan.out
    ~$ bash ./aws/ansible_env/apt/initiate.sh
    ```

#### Puppet Environment in AWS

- Code location: ./aws/puppet_env

- To spin up one puppet master and agent instances, execute steps
    
    ```
    ~$ terraform plan -out plan.out
    ~$ terraform apply -auto-approve plan.out
    ```

