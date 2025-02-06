#!/bin/bash
apt install cifs-utils
mkdir /mnt/media
echo "username=lukel\npassword=Lukejoshua13" >> /root/.fileserver_smbcredentials 
echo "//nas.lukelecain.com/Media /mnt/media cifs rw,vers=3.0,credentials=/root/.fileserver_smbcredentials,dir_mode=0775,file_mode=0775,uid=1000,gid=9999" >> /etc/fstab
