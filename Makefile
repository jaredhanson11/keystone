images-dir=./images
images=$(shell ls ${images-dir})

build-all:
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push-all:
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)