FROM python:3.7-slim

RUN apt-get update && apt-get upgrade -y

COPY requirements.txt /
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

WORKDIR /app
COPY ./logging.conf /app/
RUN mkdir -p /logs/

EXPOSE 8000
ENTRYPOINT [ "gunicorn", "-w 2", "server:app", "-b 0.0.0.0:8000", "--log-config", "/app/logging.conf" ]
