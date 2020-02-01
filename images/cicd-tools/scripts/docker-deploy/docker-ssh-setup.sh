#! /usr/bin/env bash
set -e

# Docker swarm manager connection info
manager_ip=${SWARM_MANAGER_IP}
manager_user=${SWARM_MANAGER_USER}
manager_pubkey=${SWARM_MANAGER_PUBKEY}

# Start SSH agent
eval "$(ssh-agent -s)"
# Add ssh key
ssh-add - <<< "${SSH_DEPLOY_KEY}"

# Add docker swarm manager to known_hosts
echo "${SSH_DEPLOY_KEY}" > ~/.ssh/id_rsa
# Setup docker to connect to remote host
export DOCKER_HOST=ssh://${maanger_user}@${manager_ip}
