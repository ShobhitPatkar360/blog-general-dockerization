#!/bin/bash

# setting up dashboard, Cloning github repository
cd /application

echo "Trying to pull SERVICE1_REPO_NAME" >> /tmp/user_data_log

# setting substitution url
git config --global url."https://__github_username:__github_token@github.com".insteadOf "https://github.com"

# pull the latest changes of a particular branch for service1 
git clone __repo_url.git >> /tmp/user_data_log 2>&1
cd $SERVICE1_REPO_NAME
git fetch origin __branch_name
git checkout -b __branch_name origin/__branch_name
git pull


# pull the latest changes of a particular branch for service2

# pull the latest changes of a particular branch for service3

# unsetting substitution url
git config --global --unset url."https://__github_username:__github_token@github.com".insteadof "https://github.com"
