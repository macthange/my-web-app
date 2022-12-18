## Install prerequsite library Ansible control node ##############
1) Install Python3
$sudo apt install python3

2) install  python3-pip
$sudo apt install python3-pip

3) install boto3-library
sudo pip3 install boto3


## Install AWS CLI on Ansible control node ##############

1) Download installation file
$ curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
2) Unzip downloaded installation file
$ unzip awscliv2.zip
3) Run install script
sudo ./aws/install

4) Verify AWS CLI version
$ aws --version
aws-cli/2.8.4 Python/3.9.11 Linux/5.15.0-48-generic exe/x86_64.ubuntu.22 prompt/off
$

### AWS EC2 Dynamic Inventory Plugin on Ansible Control node ############

The below requirements are needed on the local controller node that executes this inventory.
5) 

$ vi /etc/ansible/asnible.cgf and  update enable follwing  plugins

[inventory]
enable_plugins = host_list, script, auto, yaml, ini, toml, aws_ec2
#
6) run the ansible.sh shell to run the playbook 
$sh ansible.sh