images-dir=./images
# Ordering of builds can be configured in ./recipes/build-scripts/images.sh
images=$(shell ./recipes/build-scripts/images.sh ${images-dir})

build: build-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push: push-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)
