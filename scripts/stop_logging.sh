#!/bin/bash
sudo kill $(cat /tmp/logs_id.txt)
echo "logging process deleted" 
