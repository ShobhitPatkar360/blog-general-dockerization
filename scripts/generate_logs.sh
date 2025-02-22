#!/bin/bash

# Providing message of log generation initilization
sudo echo "-----------------Logs Generation Initiated  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/backend_container.log

sudo docker logs -f "$SERVICE1"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE1"_container.log &
sudo docker logs -f "$SERVICE2"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE2"_container.log &
sudo docker logs -f "$SERVICE3"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE3"_container.log &

