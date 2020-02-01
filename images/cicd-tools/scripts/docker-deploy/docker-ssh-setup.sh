#! /usr/bin/env bash

# Docker swarm manager connection info
manager_ip=${SWARM_MANAGER_IP}
manager_user=${SWARM_MANAGER_USER}
manager_pubkey=${SWARM_MANAGER_PUBKEY}

# Start SSH agent
eval "$(ssh-agent -s)"
# Add ssh key
ssh-add - <<< "${SSH_DEPLOY_KEY}"

# Add docker swarm manager to known_hosts
echo "${manager_ip} ${manager_pubkey}" > ~/.ssh/known_hosts
# Setup docker to connect to remote host
docker-machine create --driver generic --generic-ip-address=${manager_ip} --generic-ssh-user=${manager_user} ${manager_ip}
