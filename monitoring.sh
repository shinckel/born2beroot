# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: shinckel <shinckel@student.42lisboa.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/18 16:06:29 by shinckel          #+#    #+#              #
#    Updated: 2023/01/18 18:18:11 by shinckel         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

arc=$(uname -a)
cpu=$(nproc --all)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
ram=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n",$3,$2,$3*100/$2}')
disk=$(df -h --total | awk 'NR==14{printf "%s/%s (%s)\n",$3,$2,$5}')
load=$(top -bn1 | grep '^%Cpu' | awk '{printf("%.1f%%"), $2}')
boot=$(who -b | awk '{printf "%s %s\n",$3, $4}')
lvm=$(lsblk | grep "lvm" | awk '{if ($1) {printf "Yes\n";exit} else {printf "No\n";exit}}')
tpc=$(netstat -an | grep ESTABLISHED | wc -l)
ulog=$(users | wc -w)
IPv4=$(hostname -I)
MAC=$(ip a show | grep ether | awk '{printf "%s\n",$2}')
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "  #Architecture: $arc
        #CPU physical: $cpu
        #vCPU: $vcpu
        #Memory Usage: $ram
        #Disk Usage: $disk
        #CPU load: $load
        #Last boot: $boot
        #LVM use: $lvm
        #Connection TCP: $tpc ESTABLISHED
        #User log: $ulog
        #Network: IP $IPv4 ($MAC)
        #Sudo: $sudo cmd"