docker-user=jaredhanson11
name=${docker-user}/cicd-tools

build:
	docker build . -t ${name}:latest
push: build
	docker push ${name}:latest