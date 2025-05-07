# set fans to automatic control
#ipmitool -I lanplus -H <iDRAC-IP> -U <iDRAC-USER> -P <iDRAC-PASSWORD> raw 0x30 0x30 0x01 0x01

# set fan controll to manual mode
ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0x30 0x01 0x00

# Set fan speed to hex 0x14 == 20% fan speed
ipmitool -I lanplus -H 192.168.0.120 -U root -P calvin raw 0x30 0x30 0x02 0xff 0x14

# set fan speed to 100 %
#ipmitool -I lanplus -H <iDRAC-IP> -U <iDRAC-USER> -P <iDRAC-PASSWORD> raw 0x30 0x30 0x02 0xff 0x64
