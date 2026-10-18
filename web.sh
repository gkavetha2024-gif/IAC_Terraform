#!/bin/bash
sudo root
sudo hostnamectl set-hostname Terraform-Server.MYPC.COM
echo "`hostname -I | awk '{print $1}'` `hostname`" >> /etc/hosts
sudo apt update
sudo apt install nginx -y
sudo apt install unzip
timedatectl set-timezone "Asia/Kolkata"
mkdir /root/d1
cd /root/d1
sudo git init
sudo git pull https://github.com/thatbeautifuldream/html-portfolio.git
sudo cp -r * /var/www/html
cd /var/www/html
cp index.html index.nginx-debian.html
rm -rf index.html