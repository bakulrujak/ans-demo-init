#!/bin/sh -x

mkdir -p /tmp/bootstrap && chown -R ubuntu:ubuntu /tmp/bootstrap
cd /tmp/bootstrap

echo "----- Perparing APT sources and Downloading packages... -----"

wget https://s3-ap-southeast-1.amazonaws.com/yojee-public-files/instance_bootstrap/ansible-bootstrap.zip
wget https://aws-codedeploy-ap-southeast-1.s3.amazonaws.com/latest/install
chmod +x ./install

echo "----- Updating APT... -----"

sleep 5
apt-get -y update

echo "----- Installing... Things... -----"

apt-get install -y language-pack-en-base unzip python-pip ruby
echo 'export LC_ALL="en_US.UTF-8"' >> ~/.bashrc && sh ~/.bashrc

echo "----- Installing AWS CLI and Ansible... -----"

pip2 install ansible awscli

echo "----- Installing Codedeploy agent... -----"

./install auto

echo "----- Executing Ansible Playbook... -----"

unzip ansible-bootstrap.zip
sleep 7
cd ansible-bootstrap
ansible-playbook -i hosts bootstrap.yml -v

echo "----- Don't leave anything behind... -----"

cd ~
sudo rm -rf /tmp/bootstrap