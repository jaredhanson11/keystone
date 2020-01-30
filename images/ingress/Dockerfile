FROM jaredhanson11/deploy-configs as configs
FROM python:3.7-alpine as builder
WORKDIR /home/workspace

COPY --from=configs /deploys ./deploys
COPY ./create-nginx-conf.py ./

RUN pip install pyaml
RUN mkdir ./output && \
    python ./create-nginx-conf.py --deploys-dir ./deploys --output-dir ./output

FROM nginx:latest

RUN rm -rf /etc/nginx/conf.d/*
COPY --from=builder /home/workspace/output /etc/nginx/conf.d
COPY ./nginx.conf /etc/nginx/nginx.conf