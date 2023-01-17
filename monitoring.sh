# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: shinckel <shinckel@student.42lisboa.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/16 19:57:16 by shinckel          #+#    #+#              #
#    Updated: 2023/01/17 18:13:44 by shinckel         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

arc=$(uname -m)
cpu=$(nproc --all)
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)
ram=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n",$3,$2,$3*100/$2}')
disk=$(df -h | awk '$NF=="/"{printf "%s/%sGB (%s)\n",$3,$2,$5}')
load=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')
boot=$(who -b | awk '{printf "%s %s\n",$3, $4}')
lvm=$(lsblk | grep "lvm" | awk '{if ($1) {printf "\033[0;32mYes\033";exit} else {printf 
"\033[0;031mNo\033[0m";exit}}')
tpc=$(netstat -an | grep ESTABLISHED | wc -l)
ulog=$(users | wc -w)
IPv4=$(hostname -I)
MAC=$(ip a show | grep ether | awk '{printf "%s\n",$2}')
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)
wall "	#Architecture: $arc
		#CPU physical: $cpu
		#vCPU: $vcpu
		#Memory Usage: $ram
		#Disk Usage: $disk
		#CPU load: $load
		#Last boot: $boot
		#LVM use: $lvm
		#Connection TCP: $tpc ESTABLISHED
		#User log: $ulog
		#Network: $IPv4 ($MAC)
		#Sudo: $sudo cmd"
