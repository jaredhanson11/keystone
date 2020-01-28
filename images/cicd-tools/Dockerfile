FROM docker

COPY ./scripts /scripts

RUN chmod -R +x /scripts \
    && apk add bash make

ENTRYPOINT [ "/bin/bash" ]
