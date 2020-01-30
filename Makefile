images-dir=./images
# Ordering of builds can be configured in ./recipes/build-scripts/images.sh
images=$(shell ./recipes/build-scripts/images.sh ${images-dir})

build:
	${MAKE} -C deploys build
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push:
	${MAKE} -C deploys push
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)