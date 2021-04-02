FROM docker

RUN apk add bash make curl jq

# github actions was setting $HOME value, so helm plugins couldn't be found
ENV XDG_CACHE_HOME=/root/.cache
ENV XDG_CONFIG_HOME=/root/.config
ENV XDG_DATA_HOME=/root/.local/share
ENV KUBECONFIG=/root/.kube/config
# kubect, helm, yq
RUN apk add openssl git --virtual .build-deps \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl \
    && curl https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz > helm.tar.gz \
    && tar -zxvf helm.tar.gz \
    && chmod +x linux-amd64/helm && mv linux-amd64/helm /usr/local/bin/helm \
    && helm plugin install https://github.com/chartmuseum/helm-push \
    && apk del .build-deps \
    && curl -L https://github.com/mikefarah/yq/releases/download/3.0.1/yq_linux_amd64 > ./yq \
    && chmod +x ./yq && mv ./yq /usr/local/bin/yq

COPY ./scripts /scripts
RUN chmod -R +x /scripts

ENTRYPOINT [ "/bin/bash" ]
