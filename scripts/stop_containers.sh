#!/bin/bash

# Stopping container, removing continer, removing image
sudo docker container stop $(sudo docker ps -aq) || true && sudo docker rm $(sudo docker ps -aq) || true 
sudo echo "-----------------Containers Stopped  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/startup.log
