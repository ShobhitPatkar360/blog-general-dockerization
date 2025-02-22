#!/bin/bash
sudo echo $$ > /tmp/logs_id.txt

# There should be a file named as "/application/Environment/env-file" having key and value in key=value format
# save it to perticular location and change directory to set it, then come back to previous directory
# Check if "env-file" exists
cd /application/Environment
if [[ ! -f "env-file" ]]; then
    echo "Error: file 'env-file' not found."
    exit 1
fi

# Read each line from "env-file" and set variables
while IFS= read -r file; do
        export $file
done < "env-file"
cd -

sudo docker volume create log-volume
run_containers.sh 
generate_logs.sh 

# holding the terminal to get logs continiously
sleep infinity
