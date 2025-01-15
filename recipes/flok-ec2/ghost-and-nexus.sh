#! /usr/bin/env bash

# This script will setup the proper configurations for the ec2 instance that runs Ghost and Nexus
# To setup:
#  2. Create EC2 instance, this script is tested using Amazon Linux 2023
#  3. Attach your ghost EFS volumn to the EC2 instance under
#    ENSURE ITS MOUNTED AT: /dev/sdb (or /dev/xvdb) 
#  4. Copy this folder (keystone/recipes/flok-ec2/) onto the instance
#  5. Change directories into the folder
#  5. Edit on the docker compose file on the machine to add the sendgrid api key
#  6. Run this script
#  7. You may need to run the final line: docker compose up -d manually because newgrp will kill the current terminal

sudo yum update
sudo yum install -y docker

sudo usermod -a -G docker ec2-user
id ec2-user
# Reload a Linux user's group assignments to docker w/o logout

# Install docker compose
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.32.3/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose


# Setup docker compose

# Enable docker to start on reboot
sudo systemctl enable docker
sudo systemctl start docker.service

# Mount EFS volume that has ghost data (ref below)
sudo mkdir /ghost
UUID=$(sudo blkid /dev/xvdb --output value | head -n 1)
echo "UUID=$UUID /ghost ext4 defaults 0 0" | sudo tee -a /etc/fstab
sudo mount -a

# Start containers forever
newgrp docker
docker compose up -d
