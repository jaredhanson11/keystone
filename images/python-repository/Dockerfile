FROM nginx

RUN mkdir -p /data; chmod -R 777 /data; rm /etc/nginx/conf.d/default.conf
COPY ./python-repository.conf /etc/nginx/conf.d/python-repository.conf