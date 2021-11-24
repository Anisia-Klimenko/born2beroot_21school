#!/bin/bash

arc=$(uname -a)

physCPU=$(lscpu | grep "^CPU(s)" | cut -d: -f2 | cut -c27-29)

virtCPU=$(nproc)

tRAM=$(free -m | grep "Mem" | awk '{print $2}')
uRam=$(free -m | grep "Mem" | awk '{print $3}')
rateRAM=$(free -m | grep "Mem" | awk '{printf("%.2f"), $3/$2*100}')

tdiskMem=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{tsum += $2} END {print tsum}')
udiskMem=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{tsum += $3} END {print usum}')
rateMem=$(df -Bm | grep "^/dev/" | grep -v "/boot$" | awk '{tsum += $2} {usum += $3} END {printf("%.2f"), usum/tsum*100}')

load=$(mpstat | grep "all" | awk '{print (100 - $12)}')

lastBoot=$(who -b | cut -d" " -f12-13)

countLVM=$(lsblk | grep "lvm" | wc -l)
boolLVM=$(if [ $countLVM -eq 0 }; then echo no; else echo yes; fi)

tcp=$(netstat -natp | grep "ESTABLISHED" | wc -l)

users=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip l | grep "link/ether" | awk '{print $2}')

comSudo=$(journalctl _COMM=sudo | grep "COMMAND" | wc -l)

wall "
#Architecture: $arc
#CPU physical: $physCPU
#CPU virtual: $virtCPU
#Memory Usage: $uRAM/$tRAM MB ($rateRAM%)
#Disk Usage: $udiskMem/$tdiskMem MB (rateMem%)
#CPU load: $load%
#Last boot: $lastBoot
#LVM use: $boolLVM
#Connections TCP: $tcp
#User log: $users
#Network: IP $ip ($mac)
#Sudo: $comSudo cmd
