FROM node:14-slim as node-builder

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash make
RUN npm install -G yarn

ENV NPM_REGISTRY='https://nexus.goflok.com/registry/npm/'
ENV NPM_EMAIL='unset'
ENV NPM_USER='unset'
ENV NPM_PASSWORD='unset'

COPY --from=jaredhanson11/cicd-tools /scripts/python /scripts/npm
COPY --from=jaredhanson11/cicd-tools /scripts/github-workflows /scripts/github-workflows

WORKDIR /build
