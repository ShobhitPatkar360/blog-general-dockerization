#!/bin/bash

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
    9. Build all images
    10.Exit Deployment
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
    build_image.sh
    fi

    if [ $num -eq 10 ]; then
    break
    fi        


    if [ $num -eq 11 ]; then
    break
    fi

done
