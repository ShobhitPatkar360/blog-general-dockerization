#!/bin/bash

# assuming no service is running currently and repo as already there


# setting substitution url
git config --global url."https://$GIT_USERNAME:$GIT_TOKEN@github.com".insteadOf "https://github.com"

# ------------FOR SERVICE 1
# go to project directory
cd /application/___
echo "Trying to pull $SERVICE1_REPO_NAME Repo" >> /tmp/user_data_log
# pull the latest changes
git pull
# build docker image
docker build -t "$DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$environment-latest" .


#----------REPEATE FOR SERVICE 2


#----------REPEATE FOR SERVICE 3


# unsetting substitution url
git config --global --unset url."https://$GIT_USERNAME:$GIT_TOKEN@github.com".insteadof "https://github.com"

# remove untagged images
docker image prune -f
