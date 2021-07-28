FROM python:3.7-slim

RUN apt-get update && apt-get upgrade -y

COPY requirements.txt /
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

WORKDIR /app
COPY ./logging.conf /app/
RUN mkdir -p /logs/

ENV PORT 8000

COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]