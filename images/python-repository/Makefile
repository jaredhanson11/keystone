docker-user=jaredhanson11
name=${docker-user}/python-repository

build:
	docker build . -t ${name}:latest
push: build
	docker push ${name}:lastest