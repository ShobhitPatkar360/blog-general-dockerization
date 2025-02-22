#!/bin/bash

echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USER --password-stdin


echo "--------------------------------------------------------------------------------"
echo "Choose the service, whose latest image you wanted to pull - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
4. All
5. Custom
"

read -p "Type the number and press enter... " num;
if [ $num -eq 1 ]; then
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest
fi

if [ $num -eq 2 ]; then
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest
fi

if [ $num -eq 3 ]; then
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest
fi

if [ $num -eq 4 ]; then
pull_image_latest.sh
fi

if [ $num -eq 5 ]; then
pull_image_custom.sh
fi
