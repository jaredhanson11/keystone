docker-user=jaredhanson11
tag=1.0.0
name=${docker-user}/serverbase

build:
	docker build . -t ${name}:${tag}
push: build
	docker push ${name}:${tag}