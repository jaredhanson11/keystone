images-dir=./images
# Ordering of builds can be configured in ./recipes/build-scripts/images.sh
images=$(shell ./recipes/build-scripts/images.sh ${images-dir})

build: build-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push: push-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)

# Related to config Docker image
docker-user=jaredhanson11
config-image-name=${docker-user}/keystone-configs
build-config:
	docker build . -t ${config-image-name}:latest
push-config: build-config
	docker push ${config-image-name}:latest