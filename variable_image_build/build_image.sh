#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "Choose the service, whose latest image you wanted to build - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
"

read -p "Type the number and press enter... " num;



if [ $num -eq 1 ]; then
cd /application/$SERVICE1_REPO_NAME
echo "Trying to pull $SERVICE1_REPO_NAME Repo" >> /tmp/user_data_log
# pull the latest changes
git pull
# build docker image
docker build -t "$DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest" .
fi



if [ $num -eq 2 ]; then
cd /application/$SERVICE2_REPO_NAME
echo "Trying to pull $SERVICE2_REPO_NAME Repo" >> /tmp/user_data_log
# pull the latest changes
git pull
# build docker image
docker build -t "$DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest" .
fi




if [ $num -eq 3 ]; then
cd /application/$SERVICE3_REPO_NAME
echo "Trying to pull $SERVICE3_REPO_NAME Repo" >> /tmp/user_data_log
# pull the latest changes
git pull
# build docker image
docker build -t "$DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest" .
fi


# remove untagged images
docker image prune -f

