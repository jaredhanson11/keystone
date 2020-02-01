FROM jaredhanson11/keysone-configs as deploys
FROM docker

COPY --from=deploys /config/deploys /deploys
COPY --from=deploys /config/files /files
COPY ./scripts /scripts

RUN chmod -R +x /scripts \
    && apk add bash make curl

ENTRYPOINT [ "/bin/bash" ]
