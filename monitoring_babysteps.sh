# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring_babysteps.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: shinckel <shinckel@student.42lisboa.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/16 19:57:16 by shinckel          #+#    #+#              #
#    Updated: 2023/01/17 18:20:15 by shinckel         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

#the architecture of your OS and its kernel version
#variable=$(command output)
arc=$(uname -m)

#the number of physical processors[pseudo-file][/proc/cpuinfo]
cpu=$(nproc --all)

#the number of virtual processors[grep]-> search words/strings in given file
# pipe[|]-> it chains commands together, first's output is the next's input
# [wc -l]-> word count/ number of lines-> two collumnar output
vcpu=$(cat /proc/cpuinfo | grep processor | wc -l)

#the current available RAM on your server and its utilization rate(%)
#[free -m]-> displays output in mebibytes | [awk]-> print a text file
#[awk]-> NF and NR are built in variables-> [NR]number of records(line)
#[NF]-> number of fields in a record(e.g.student with 3 grades= 3 fields)
#[$3]-> third argument given to the script-> positional argument
ram=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)\n",$3,$2,$3*100/$2}')

#the current available memory on your server and its utilization rate(%)
#[df -h]-> amount of disk space available | h stands for human-readable
#if no file name is passed as argument-> space of all mounted file systems 
disk=$(df -h | awk '$NF=="/"{printf "%s/%sGB (%s)\n",$3,$2,$5}')

#the current utilization rate of your processors(%)
load=$(top -bn1 | grep load | awk '{printf "%.2f\n", $(NF-2)}')

#the date and time of the last reboot
#[who -b]-> it displays the last system reboot date and time
boot=$(who -b | awk '{printf "%s %s\n",$3, $4}')

#whether LVM is active or not
#LVM-> Logical Volume Management-> system of partitions-> abstract your storage
#Logical Volume is synonymous to Virtual/Logical Partition
lvm=$(lsblk | grep "lvm" | awk '{if ($1) {printf "\033[0;32mYes\033";exit} else {printf 
"\033[0;031mNo\033[0m";exit}}')


#the number of active connections
#[netstat]-> Active Internet connections (servers and established)
#[netstat][-an]-> [a]all active tcp + [n]no attempt showing names(only numbers) 
#[netstat | grep -i established | wc -l]
#[ss]-> socket statistics-> show information similar to [netstat]
#[ss][-t]-> displays only TCP sockets
tpc=$(netstat -an | grep ESTABLISHED | wc -l)

#the number of users using the server
#[tr]-> transform strings or delete characters from the string-> search/replace
#[wc -w]-> word count words
ulog=$(users | wc -w)

#the IPv4 address of your server and its MAC(media access control) address
#MAC-> hardware address-> unique value associated with a network adapter
#MAC-> six pairs of hexadecimal numbers separated by colons
#MAC-> [ip a show]
IPv4=$(hostname -I)
MAC=$(ip a show | grep ether | awk '{printf "%s\n",$2}')

#the number of commands executed with the sudo program
sudo=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

#at the server startup, the script will display some information every 10min
#[wall]-> send a message to everybody's terminal-> message as a wall's argument
wall " #Architecture: $arc
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

#how to interrupt the script without modifying it?
#[crontab]list of commands that you want to run on a regular schedule
#[sudo crontab -u root -e]
#@reboot sleep 15; sh 
#*/10 * * * *(script path)  
