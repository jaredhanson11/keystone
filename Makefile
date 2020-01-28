images-dir=./images
images=$(shell ls ${images-dir})

build:
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push:
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)