#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "Choose the number, whose image you wanted to remove - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
4. All
5. Custom
"

read -p "Type the number and press enter... " num;
if [ $num -eq 1 ]; then
sudo docker image rmi $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest || true
fi

if [ $num -eq 2 ]; then
sudo docker image rmi $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest || true
fi

if [ $num -eq 3 ]; then
sudo docker image rmi $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest || true
fi

if [ $num -eq 4 ]; then
# removing all images
sudo docker image rmi $(sudo docker image ls -aq) || true
fi

if [ $num -eq 5 ]; then
delete_image_custom.sh
fi
