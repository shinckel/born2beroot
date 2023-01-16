# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring_babysteps.sh                            :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: shinckel <shinckel@student.42lisboa.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/01/16 19:57:16 by shinckel          #+#    #+#              #
#    Updated: 2023/01/16 23:55:16 by shinckel         ###   ########.fr        #
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
boot=$(who -b | )

#whether LVM is active or not
lvm=$()

#the number of active connections
tpc=$()

#the number of users using the server
user=$()

#the IPv4 address of your server and its MAC(media access control) address
net=$()

#the number of commands executed with the sudo program
sudo=$()

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
#User log: $user
#Network: $net
#Sudo: $sudo cmd"

#how to interrupt the script without modifying it? [cron]