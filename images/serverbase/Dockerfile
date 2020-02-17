FROM python:3.7-alpine

# This doubles our images size (112MB -> 211MB)
# but gunicorn errors without so have to leave for now.
RUN apk add --no-cache gcc libc-dev

COPY requirements.txt /
RUN pip install -r /requirements.txt
RUN rm /requirements.txt

WORKDIR /app

EXPOSE 8000
ENTRYPOINT [ "gunicorn", "-w 2", "server:app", "-b 0.0.0.0:8000" ]
