FROM python:3.7-alpine

RUN apk add bash
RUN apk add --no-cache --virtual .build-deps gcc libc-dev libffi-dev openssl-dev python3-dev && \
    pip install --upgrade setuptools wheel twine && \
    apk del .build-deps

ENV TWINE_USERNAME='unset'
ENV TWINE_PASSWORD='unset'
ENV TWINE_REPOSITORY_URL='unset'
ENV TWINE_NON_INTERACTIVE='1'

COPY --from=jaredhanson11/cicd-tools /scripts/python /scripts/python
COPY --from=jaredhanson11/cicd-tools /scripts/github-workflows /scripts/github-workflows

WORKDIR /build
