sudo useradd -m steam
sudo passwd steam
sudo -u steam -s
cd /home/steam
sudo apt update; sudo apt install software-properties-common; sudo apt-add-repository non-free; sudo dpkg --add-architecture i386; sudo apt update
sudo apt install steamcmd
mkdir server
steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam/server +login anonymous +app_update 1690800 +quit
exit
sudo nano /etc/systemd/system/satisfactoryserver.service 

'''
  [Unit]
  Description=Satisfactory Dedicated Server
  Wants=network-online.target
  After=network-online.target
  
  [Service]
  Environment=SteamAppId=1690800
  Environment=LD_LIBRARY_PATH=/home/steam/server:$LD_LIBRARY_PATH
  Type=simple
  Restart=on-failure
  RestartSec=10
  User=steam
  Group=steam
  WorkingDirectory=/home/steam/server
  ExecStartPre=/usr/games/steamcmd +@sSteamCmdForcePlatformType linux +force_install_dir /home/steam/server +login anonymous +app_update 1690800 +quit
  ExecStart=/home/steam/server/FactoryServer.sh \
      -unattended \
      -log \
      -BeaconPort=15000 \
      -ServerQueryPort=15777 \
      -Port=7777 \
      -multihome=0.0.0.0
  
  [Install]
  WantedBy=multi-user.target
'''

sudo systemctl enable satisfactoryserver
sudo systemctl start satisfactoryserver
