# HomeLab
A description of my self hosted applications and network for my own use for when it breaks and so that i can get feedback from others on best practices

## Run Ctinit.sh
```sh
bash -c "$(wget -qLO - https://raw.githubusercontent.com/SenorC4/HomeLab/refs/heads/main/ctinit.sh)"
```

## Run smbMount.sh
```sh
bash -c "$(wget -qLO - https://raw.githubusercontent.com/SenorC4/HomeLab/refs/heads/main/smbMount.sh)"
```

## Hardware

PVE:

Platform: Dell r430

CPU: 2 x E5-2690V4 @ 2.60 GHz (56 threads total)

RAM: 128GB DDR4

Drives: 3 x 500gb Samsung 860 EVO + 2 x 2TB Samsung 870 QVO

PVE1:

Platform: HP dl360 G9

CPU: 2 x E5-2690V4 @ 2.60 GHz (56 threads total)

RAM: 128GB DDR4

Drives: 2 x 1Tb Samsung 970 EVO + 2 x 2TB Samsung 970 EVO + 2 x 128GB 870 EVO

PVE2: (NAS)

Platform: Dell r330

CPU: 2 x E5-2690V4 @ 2.60 GHz (56 threads total)

RAM: 64GB DDR4

Drives: 4 x 4Tb Seagate IronWolf Pro + 1 x 1TB Samsung 970 EVO

Pi1:

Raspiberry Pi 4

Pi2:

Raspiberry Pi 4

## Pi's

The Pi's run my main pihole and are configured the same as the CT's below

## Proxmox
The Hypervisor that runs it all

I originally started my lab running unraid as my hypervisor, and while it was a good starting point and a great platform I was convinced by a coworker to switch to proxmox for its utilization of ZFS, its speed when spinning up VM's and CT's, and the fact that I wasn't using unraid as a file share. 

On hypervisor I have:

ACME: ssl cert for the web interface using proxmox's built in certbot functionality

ZFS pool: (prmoxox) 2 x 2TB Samsung 870 QVO raid1
          (storage) 3 x 500gb Samsung 860 EVO in raidz1

pve-nag-buster: package that disables the paid version pop-up for proxmox

## CT's

All of my CT's are running Debian 12 with the unnatended-upgrades package installed

VPN.lukelecain.com - 

  * [PIVPN](https://www.pivpn.io/) using wireguard for remote access and managment

WWW.lukelecain.com - 

  * www.lukelecain.com on nginx
  * Certbot for external www
    
Nessus.lukelecain.com - 

  * Nessus essentials (runs every wedneday on all containers and VM's)
  * cp fullchain.pem /opt/nessus/com/nessus/CA/servercert.pem cp privkey.pem /opt/nessus/var/nessus/CA/serverkey.pem
  * Certbot for local web interface

Bitwarden.lukelecain.com -

  * Docker
     * [vaultwarden](https://github.com/dani-garcia/vaultwarden) - bitwarden_rs (alternative docker container for self hosted bitwarden)
     * sudo docker run -d --name bitwarden -e ROCKET_TLS='{certs="/ssl/live/bitwarden.lukelecain.com/fullchain.pem",key="/ssl/live/bitwarden.lukelecain.com/privkey.pem"}' -v /etc/letsencrypt/:/ssl/ -v /vw-data/:/data/ -p 443:80 vaultwarden/server:latest
  * certbot for vaultwarden web portal

Home.lukelecain.com - 
  
  * [Homepage](https://github.com/gethomepage/homepage)
  * A dashboard for monitoring and accessing all of my services

Docker.lukelecain.com -
  * Docker
    * [portainer](https://docs.portainer.io/start/install-ce/server/docker/linux) for managment
    * [cloudflare-ddns](https://github.com/timothymiller/cloudflare-ddns) for DDNS
    * [JellyFin](https://jellyfin.org/) for local media streaming

Mine.lukelecain.com - 

  * running [paper MC](https://papermc.io/downloads/paper) for increased performance
    * cron: @reboot cd /root/minecraft && java -Xms4G -Xmx8G -jar paper-x.xxx.x-xxx.jar --nogui

C2.lukelecain.com - 

  * Command and Control server for [Hak5](https://docs.hak5.org/cloud-c2/) Wifi-Pineapple
  * Not finished

## VM's

Kali - my main kali box for HackTheBox/internal testing

Kali Purple - why not?

Metasploitable2 - a linux vm purpose-built to be exploited by the tool Metasploit

Metasploitable3-Ubuntu - The newest verison of metasploitble

Metasploitable3-Win2k8 - A windows version of metasploitable

DC-01 - A windows server 2022 that I have as a Domain controller for luke.lab (mostly for Active directory testing)

Windows 11 - Utility VM that I use as a secondary workstation 



