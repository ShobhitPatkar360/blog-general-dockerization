#!/bin/bash

echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USER --password-stdin


echo "--------------------------------------------------------------------------------"
echo "Choose the service - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
"

read -p "Type the number and press enter... " input1;


if [ $input1 -eq 1 ]; then
service=$SERVICE1

elif [ $input1 -eq 2 ]; then
service=$SERVICE2

elif [ $input1 -eq 3 ]; then
service=$SERVICE3

else
echo "You provided invalid service option"
exit 0
fi



echo "--------------------------------------------------------------------------------"
echo "Choose the environment - 
1. Dev
2. Test
3. Prod
"

read -p "Type the number and press enter... " input2;


if [ $input2 -eq 1 ]; then
environment="dev"

elif [ $input2 -eq 2 ]; then
environment="test"

elif [ $input2 -eq 3 ]; then
environment="prod"

else
echo "You provided invalid service option"
exit 0
fi

read -p "Provide the tag: " tag

# generate image name
image_name="$DOCKERHUB_USER/$DOCKERHUB_REPO:$service-$environment-$tag"

# Print the combined result
echo "Trying to pull image $image_name"

# removing previous image if any existing
sudo docker rmi "$DOCKERHUB_USER/$DOCKERHUB_REPO:$service-$ENVIRONMENT-latest" || true

sudo docker pull $image_name

# retagging the image
echo "retagging image from $image_name to $DOCKERHUB_USER/$DOCKERHUB_REPO:$service-test-latest"
sudo docker tag $image_name "$DOCKERHUB_USER/$DOCKERHUB_REPO:$service-$ENVIRONMENT-latest"
