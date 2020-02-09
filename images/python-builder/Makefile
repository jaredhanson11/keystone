docker-user=jaredhanson11
name=${docker-user}/python-builder

build:
	docker build . -t ${name}:latest
push: build
	docker push ${name}:latest