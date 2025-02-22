#!/bin/bash


echo "--------------------------------------------------------------------------------"
echo "Choose the service for which you wanted to see the logs - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
"

read -p "Type the number and press enter... " num;
clear

if [ $num -eq 1 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE1"_container.log
fi

if [ $num -eq 2 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE2"_container.log
fi

if [ $num -eq 3 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE3"_container.log
fi
