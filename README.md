# HomeLab
A description of my self hosted applications and network for my own use for when it breaks and so that i can get feedback from others on best practices

## Hardware

PV0:

Platform: Dell r430

CPU: 2 x E5-2690V4 @ 2.60 GHz (56 threads total)

RAM: 128GB DDR4

Drives: 3 x 500gb Samsung 860 EVO + 2 x 2TB Samsung 870 QVO

## Proxmox
The Hypervisor that runs it all

I originally started my lab running unraid as my hypervisor, and while it was a good starting point and a great platform I was convinced by a coworker to switch to proxmox for its utilization of ZFS, its speed when spinning up VM's and CT's, and the fact that I wasn't using unraid as a file share. 

On hypervisor I have:

ACME: ssl cert for the web interface using proxmox's built in certbot functionality

ZFS pool: (rpool) of the 5 drives listed earlier in raid0? (this neeeds to change)

pve-nag-buster: package that disables the paid version pop-up for proxmox

## CT's

All of my CT's are running Debian 12 with the unnatended-upgrades package installed

VPN - 

  * PIVPN using wireguard for remote access and managment
  * cloudflare-ddns-updater
  * cron: */10 * * * * /home/luke/cloudflare-ddns-updater/cloudflarevpn2 (vpn A)
  * cron: */10 * * * * /home/luke/cloudflare-ddns-updater/cloudflareddns2 (proxied A)

WWW - 

  * www.lukelecain.com on nginx
  * Certbot for external www
    
Nessus - 

  * Nessus essentials (runs every wedneday on all containers and VM's)
  * Certbot for local web interface

NS - 

  * Bind9 for local lukelecain.com use
  * Would like pihole or some sort of adblock
  * would also like centralized certbot that sends wildcard certs to other ct's

Minecraft - 

  * running paper MC for increased performance
  * cron: @reboot cd /root/minecraft && java -Xms4G -Xmx8G -jar paper-x.xxx.x-xxx.jar --nogui

C2 - 

  * Command and Control server for Hak5 Wifi-Pineapple
  * Not finished

## VM's

Kali - my main kali box for HackTheBox/internal testing

Kali Purple - why not?

Metasploitable2 - a linux vm purpose-built to be exploited by the tool Metasploit

Metasploitable3-Ubuntu - The newest verison of metasploitble

Metasploitable3-Win2k8 - A windows version of metasploitable

DC-01 - A windows server 2022 that I have as a Domain controller for luke.lab (mostly for Active directory testing)

Windows 11 - Utility VM that I use as a secondary workstation 



