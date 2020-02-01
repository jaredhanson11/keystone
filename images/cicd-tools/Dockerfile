FROM jaredhanson11/deploy-configs as deploys
FROM docker

COPY --from=deploys /deploys /deploys
COPY ./scripts /scripts

RUN chmod -R +x /scripts \
    && apk add bash make curl

ENTRYPOINT [ "/bin/bash" ]
