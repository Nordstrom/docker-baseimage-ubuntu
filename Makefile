container_name := baseimage-ubuntu
container_registry := quay.io/nordstrom
container_release := 16.04
build_image ?= baseimage-ubuntu-build
tar_file ?= rootfs.tar
proxy_url := http://webproxysea.nordstrom.net:8181
build_args ?= --build-arg http_proxy=$(proxy_url) --build-arg https_proxy=$(proxy_url)

.PHONY: build/build-image build/image tag/image push/image

build/build-image: Dockerfile.build $(build_container_prereqs)
	rm -f $(tar_file)
	docker build -t $(build_image) $(build_args) -f Dockerfile.build .
	docker create --name $(build_image) $(build_image)
	docker export $(build_image) > $(tar_file)
	docker rm $(build_image)

build/image: Dockerfile build/build-image $(build_container_prereqs)
	docker build -t $(container_name) .

tag/image: build/image
	docker tag $(container_name) $(container_registry)/$(container_name):$(container_release)

push/image: tag/image
	docker push $(container_registry)/$(container_name):$(container_release)

