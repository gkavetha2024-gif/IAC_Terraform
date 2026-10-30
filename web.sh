#!/bin/bash
sudo hostnamectl set-hostname ANSIBLECONTROLLER.MYPC.COM
echo "`hostname -I | awk '{print $1}'` `hostname`" >> /etc/hosts
sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible -y
