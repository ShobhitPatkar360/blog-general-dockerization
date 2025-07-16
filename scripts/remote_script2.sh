#!/bin/bash

# There should be a file named as "/application/Environment/env-file" having key and value in key=value format
# save it to perticular location and change directory to set it, then come back to previous directory
# Check if "env-file" exists
cd /application/Environment
if [[ ! -f "env-file" ]]; then
    echo "Error: file 'env-file' not found."
    exit 1
fi

# Read each line from "env-file" and execute cat
while IFS= read -r file; do
        export $file
done < "env-file"
cd -

# remve old deployment logs
rm -rf /tmp/deployment_remote.log 
echo "------------------------------------Deployment started :- $(date)--------------------------------" >> /tmp/deployment_remote.log

# stoping the service
systemctl stop start_all.service

# update docker images
pull_image_latest.sh >> /tmp/deployment_remote.log 2>&1

# remove untagged images
docker image prune -f

# restarting services and acknowledgement
systemctl start start_all.service


sleep 20
echo "$(docker ps -a)" >> /tmp/deployment_remote.log
echo "------------------------------------Deployment Finished :- $(date)-------------------------------" >> /tmp/deployment_remote.log

# Triggering Remote logs actions
curl -X POST "https://api.github.com/repos/$GITHUB_USER/$SERVICE2_REPO/actions/workflows/$WORKFLOW_FILE/dispatches" \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -d @- <<EOF
{
  "ref": "$BRANCH",
  "inputs": {
    "deploy-env": "$ENVIRONMENT"
  }    
}
EOF
