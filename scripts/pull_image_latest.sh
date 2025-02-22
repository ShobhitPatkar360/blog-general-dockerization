#!/bin/bash

echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USER --password-stdin

# pulling the images at startup
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest
