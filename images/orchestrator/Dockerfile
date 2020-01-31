FROM docker/compose:alpine-1.25.3 as docker
FROM jaredhanson11/serverbase
RUN apk add git openssh-client
COPY --from=docker /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker /usr/local/bin/docker-compose /usr/local/bin/docker-compose
RUN pip install pyaml
COPY ./server.py ./
ENTRYPOINT [ "python", "server.py"]