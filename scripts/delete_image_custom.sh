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
