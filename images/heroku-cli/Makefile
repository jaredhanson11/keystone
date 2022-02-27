docker-user=jaredhanson11
name=${docker-user}/heroku-cli

build:
	docker build . -t ${name}:latest
push: build
	docker push ${name}:latest