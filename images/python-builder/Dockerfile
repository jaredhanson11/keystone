FROM python:3.7-slim

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y bash make
RUN pip install --upgrade setuptools wheel twine

ENV TWINE_USERNAME='unset'
ENV TWINE_PASSWORD='unset'
ENV TWINE_REPOSITORY_URL='unset'
ENV TWINE_NON_INTERACTIVE='1'

COPY --from=jaredhanson11/cicd-tools /scripts/python /scripts/python
COPY --from=jaredhanson11/cicd-tools /scripts/github-workflows /scripts/github-workflows

WORKDIR /build
