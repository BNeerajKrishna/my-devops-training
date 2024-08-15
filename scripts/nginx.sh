#!/bin/bash
date | tee -a /home/ubuntu/go-user.log
echo "updating packages before installing nginx" | tee -a /home/ubuntu/nginx-user.log
apt-get update
echo "installing nginx" | tee -a /home/ubuntu/nginx-user.log
apt install -y nginx 
if [ $? -eq 0 ]; then
    echo "Nginx has been successfully installed" | tee -a /home/ubuntu/nginx-user.log
else
    echo "Failed to install Nginx" | tee -a /home/ubuntu/nginx-user.log
    exit 1
fi
echo "start nginx" | tee -a /home/ubuntu/nginx-user.log
systemctl start nginx