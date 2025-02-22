#!/bin/bash

sudo echo "-----------------Containers Started  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/startup.log

# map essential file by yourself->  -v <source_file_path>:<file_path_in_container>
docker run -d --name "$SERVICE1"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log
docker run -d --name "$SERVICE2"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log
docker run -d --name "$SERVICE3"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log

