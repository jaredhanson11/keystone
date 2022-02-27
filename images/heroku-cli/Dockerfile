FROM ubuntu:18.04

ENV HEROKU_API_KEY=unset

RUN apt-get update && apt-get install wget -y
ADD https://cli-assets.heroku.com/install.sh install.sh

RUN chmod +x install.sh && ./install.sh