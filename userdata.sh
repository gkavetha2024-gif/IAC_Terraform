#!/bin/bash
sudo root
sudo apt-get update
sudo hostnamectl set-hostname NODEWEBCONTROLLER.MYPC.COM
echo "`hostname -I | awk '{print $1}'` `hostname`" >> /etc/hosts
sudo apt-get install apache2 -y
# sudo apt-get install unzip
timedatectl set-timezone "Asia/Kolkata"
# mkdir /root/d1
# cd /root/d1
# sudo git init
# sudo git pull https://github.com/mdn/beginner-html-site-styled.git
# sudo cp -r * /var/www/html
# cd /var/www/html
# cp index.html index.nginx-debian.html
# rm -rf index.html