# Task 3: General Dockerization

![image.png](images/image.png)

# Objective

To create an Environment where it is easy to deploy a muilti-architecture application with a few clicks

# Final Result

We get a running application which is based on multiple containers executing in the server. We just provided the information of the docker images and then all the services are automatically set up, Stramlined the management of containers.

# Our Approach

We created some scripts (bash scripts) which manages the containers and images. Instead of hard code we provided the variables for the container and images which adjust the docker command according to provided service name. 

We had also created a deployment console which provides an interface for management of containers, images, logs, starting and stopping of services.

![image.png](images/image%201.png)

# Procedure

Keep in mind to run all the commands as a root user for the following instructions. 

## Step 1: Install Docker

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

```

## Step 2: Make directory structure

```yaml
# path for environment credentials
mkdir -p /application/Environment
```

## Step 3: Set up variables for dockerized environment

create a file - `nano /application/Environment/env-file`

```yaml
DOCKERHUB_USER=shobhit
DOCKERHUB_TOKEN=my_token
DOCKERHUB_REPO=my_repo
SERVICE1=frontend
SERVICE2=backend
SERVICE3=database
ENVIRONMENT=dev
service=backend
environment=dev
```

As provided above “service” and “environment” is default values that removes some error, just leave it as it is. Edit the remaining fields as per your requirement of the current server.

## Step 4: Set up Scripts

```yaml
# go to proper directory
cd /application

# clone the repo
git clone https://github.com/ShobhitPatkar360/blog-general-dockerization.git

# go to scripts directory
cd blog-general-dockerization/scripts

# add the scripts to bin directory
cp -r * /usr/local/bin/

# make the scripts exeucutable
chmod +x /usr/local/bin/*
```

## Step 5: Set up Daemon service

```yaml
ln -s /usr/local/bin/start_all.service /etc/systemd/system/
systemctl daemon-reload
```

## Step 6: Start the service

1. Execute the command `deploy.sh` to open the deployment console.
2. Pull all the docker images.
3. Start your services
4. See the logs.
5. Test your application.

# Files and Scripts

## Docker image management

### show_images.sh

```bash
#!/bin/bash
docker image ls
```

### pull_image_custom.sh

```bash
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
```

### pull_image_latest.sh

```bash
#!/bin/bash

echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USER --password-stdin

# pulling the images at startup
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest
sudo docker pull $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest
```

### pull_image.sh

```bash
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
```

### delete_image_custom.sh

```bash
#!/bin/bash

echo "--------------------------------------------------------------------------------"
#!/bin/bash
sudo docker image ls

echo ""
# Prompt user for image IDs to delete
read -p "Enter the image IDs to delete (comma-separated): " image_ids

# Convert comma-separated IDs into an array
IFS=',' read -r -a ids_array <<< "$image_ids"

echo "Deleting images..."
# Loop through each image ID and delete it
for id in "${ids_array[@]}"; do
    echo "Deleting image: $id"
    docker rmi -f "$id"
done

echo "Custom Image deletion completed."
```

### delete_image.sh

```bash
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
```

## Docker Container management

### show_containers.sh

```bash
#!/bin/bash
docker ps -a
```

### run_containers.sh

```bash
#!/bin/bash

sudo echo "-----------------Containers Started  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/startup.log

# map essential file by yourself->  -v <source_file_path>:<file_path_in_container>
docker run -d --name "$SERVICE1"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE1-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log
docker run -d --name "$SERVICE2"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE2-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log
docker run -d --name "$SERVICE3"_container --network host $DOCKERHUB_USER/$DOCKERHUB_REPO:$SERVICE3-$ENVIRONMENT-latest >> /var/lib/docker/volumes/log-volume/_data/startup.log

```

### stop_containers.sh

```bash
#!/bin/bash

# Stopping container, removing continer, removing image
sudo docker container stop $(sudo docker ps -aq) || true && sudo docker rm $(sudo docker ps -aq) || true 
sudo echo "-----------------Containers Stopped  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/startup.log
```

### deploy.sh

```bash
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

while true; do

    echo "--------------------------------------------------------------------------------"
    echo "Choose the number according to your requirement - 
    1. Show Containers
    2. Show Images
    3. Start All Services
    4. Stop All Services    
    5. Delete Images
    6. Pull Images
    7. Show Instructions
    8. Show Logs
    9. Exit Deployment
    "

    read -p "Type the number and press enter... " num;
    echo "--------------------------------------------------------------------------------"
    
    # clar the screen
    clear 

    if [ $num -eq 1 ]; then
    show_containers.sh
    fi

    if [ $num -eq 2 ]; then
    show_images.sh
    fi

    if [ $num -eq 3 ]; then
    systemctl start start_all.service
    fi

    if [ $num -eq 4 ]; then
    systemctl stop start_all.service
    fi

    if [ $num -eq 5 ]; then
    delete_image.sh
    fi

    if [ $num -eq 6 ]; then
    pull_image.sh
    fi

    if [ $num -eq 7 ]; then
    cat /usr/local/bin/instructions.txt
    fi

    if [ $num -eq 8 ]; then
    get_logs.sh
    fi

    if [ $num -eq 9 ]; then
    break
    fi

    if [ $num -eq 10 ]; then
    break
    fi        

    if [ $num -eq 11 ]; then
    break
    fi

done 
```

## Docker logs management

### generate_logs.sh

```bash
#!/bin/bash

# Providing message of log generation initilization
sudo echo "-----------------Logs Generation Initiated  at $(date)-----------------" >> /var/lib/docker/volumes/log-volume/_data/backend_container.log

sudo docker logs -f "$SERVICE1"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE1"_container.log &
sudo docker logs -f "$SERVICE2"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE2"_container.log &
sudo docker logs -f "$SERVICE3"_container >> /var/lib/docker/volumes/log-volume/_data/"$SERVICE3"_container.log &

```

### get_logs.sh

```bash
#!/bin/bash

echo "--------------------------------------------------------------------------------"
echo "Choose the service for which you wanted to see the logs - 
1. $SERVICE1
2. $SERVICE2
3. $SERVICE3
"

read -p "Type the number and press enter... " num;
clear

if [ $num -eq 1 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE1"_container.log
fi

if [ $num -eq 2 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE2"_container.log
fi

if [ $num -eq 3 ]; then
tail -n 800 /var/lib/docker/volumes/log-volume/_data/"$SERVICE3"_container.log
fi
```

### stop_logging.sh

```bash
#!/bin/bash
sudo kill $(cat /tmp/logs_id.txt)
echo "logging process deleted" 
```

## Service management

### start_all.service

```bash
[Unit]
Description=Simple systemd service to start all the services
After=network.target

[Service]
ExecStart=all_start.sh
ExecStop=all_stop.sh
Restart=on-failure
User=root
Group=root

[Install]
WantedBy=multi-user.target
```

### all_start.sh

```bash
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

```

### all_stop.sh

```bash
#!/bin/bash
stop_containers.sh
stop_logging.sh
```

# Helpful code

### code to set env variable

```bash
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
```

# Image Creation

### Dockerfile (an example)

```bash
# Settin your base image
FROM nginx:latest

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy custom HTML files from current directory to the container
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 81
EXPOSE 81

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
```

### Github Action: push_to_dockerhub.yaml

```bash
name: Push image to dockerhub

on:
  workflow_dispatch:
    inputs:
      deploy-env:
        description: 'Select an environment'
        type: choice
        options:
          - dev
          - test
          - prod
        required: true
      custom-tag:
        description: "Giving the tag to docker image"
        required: true
        default: "latest"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      # Step 1: Environment 
      - name: Work with environment
        run: |
          echo "Selected environment is ${{ inputs.deploy-env }}"
          echo "DOCKERHUB_REPO=my_repo" >> $GITHUB_ENV
          echo "SERVICE_NAME=backend" >> $GITHUB_ENV          

			# Step 2: Selecting source
      - name: Checkout code
        uses: actions/checkout@v3

      # Step 3: Log in to Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      # Step 4: Build the Docker image
      - name: Build Docker image
        run: |
          docker build -t ecomsuiteadmin/$DOCKERHUB_REPO:$SERVICE_NAME-${{ inputs.deploy-env }}-latest .

      # Step 5: Push the latest Docker image
      - name: Push Docker image to Docker Hub
        run: |
          docker push $DOCKER_USERNAME/$DOCKERHUB_REPO:$SERVICE_NAME-${{ inputs.deploy-env }}-latest
          
      # Step 6: Push the tagged image
      - name: Push tagged image to Docker Hub
        run: |
          docker tag $DOCKER_USERNAME/$DOCKERHUB_REPO:$SERVICE_NAME-${{ inputs.deploy-env }}-latest $DOCKER_USERNAME/$DOCKERHUB_REPO:$SERVICE_NAME-${{ inputs.deploy-env }}-${{ inputs.custom-tag }}
          docker push $DOCKER_USERNAME/$DOCKERHUB_REPO:$SERVICE_NAME-${{ inputs.deploy-env }}-${{ inputs.custom-tag }}
          
```

# Conclusion

We got a dockerized micro-service application, with streamlined management. It’s easy to set up.