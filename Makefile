scripts-dir=./images/cicd-tools/scripts
# Ordering of builds can be configured in ./recipes/build-scripts/images.sh
images-dir=./images
images=$(shell ./recipes/build-scripts/images.sh ${images-dir})
# Ordering of charts can be configured in ./recipes/build-scripts/charts.sh
charts-dir=./charts
charts=$(shell ./recipes/build-scripts/charts.sh ${charts-dir})

build-images: build-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} build;)
push-images: push-config
	$(foreach image, ${images}, $(MAKE) -C ${images-dir}/${image} push;)

# This job is run under the assumption you're in the cicd-tools container.
push-charts:
	$(foreach chart, ${charts}, ${scripts-dir}/kube/helm-push.sh ${charts-dir}/${chart})
