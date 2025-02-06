#!/bin/bash
apt install cifs-utils -y
mkdir /mnt/media
read -p "Enter your username: " username
read -p "Enter your password: " password

echo "username=$username\npassword=$password" >> /root/.fileserver_smbcredentials 
echo "//nas.lukelecain.com/Media /mnt/media cifs rw,vers=3.0,credentials=/root/.fileserver_smbcredentials,dir_mode=0775,file_mode=0775,uid=1000,gid=9999" >> /etc/fstab
