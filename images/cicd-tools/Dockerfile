FROM docker

COPY ./scripts /scripts

RUN chmod -R +x /scripts \
    && apk add bash make curl

# doctl, kubect, helm
RUN apk add openssl git --virtual .build-deps \
    && curl -sL https://github.com/digitalocean/doctl/releases/download/v1.37.0/doctl-1.37.0-linux-amd64.tar.gz | tar -xzv \
    && chmod +x ./doctl && mv ./doctl /usr/local/bin/doctl \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.17.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && helm plugin install https://github.com/chartmuseum/helm-push \
    && apk del .build-deps

ENTRYPOINT [ "/bin/bash" ]
