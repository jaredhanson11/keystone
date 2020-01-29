#! /bin/bash
# This script needs to be copy pasted onto server to setup keystone repo

# Create ssh key for access to git repos
ssh-keygen -t rsa -b 4096 -C "endergygroup@gmail.com" -P "" -f ${HOME}/.ssh/id_rsa
echo ${HOME}/.ssh/id_rsa.pub
echo 
echo "Add the public key above to the deploy keys at https://github.com/jaredhanson11/keystone.git."

while [ "$did_add" != "yes"]; do
    echo "Once the public key is added on Github, type \"yes\" to continue"
    read did_add
done

cd ${HOME}
git clone git@github.com:jaredhanson11/keystone.git

./keystone/recipes/remote-setup/ubuntu-18.04/2-setup.sh