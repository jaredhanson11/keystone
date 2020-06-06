#!/usr/bin/env bash
PATH=/usr/local/bin/:$PATH
echo "Starting script at $(date)"
. $HOME/.bash_profile &&
printenv
cd ${SUMMN_MISC_PATH} &&
cd ./SummnAppPrototype/ios &&
bundle exec fastlane beta ;
sleep 10
pmset sleepnow
