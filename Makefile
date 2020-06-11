IMAGE_NAME := baseimage-ubuntu
IMAGE_REGISTRY := artifactory.nordstrom.com/docker/app00738
IMAGE_TAG := 18.04
# FROM_IMAGE_NAME := docker.io/library/ubuntu
# FROM_IMAGE_TAG := 18.04
BUILD_IMAGE_NAME := $(IMAGE_NAME)-build-temp

ifdef http_proxy
BUILD_ARGS += --build-arg http_proxy=$(http_proxy)
BUILD_ARGS += --build-arg https_proxy=$(http_proxy)
endif

.PHONY: push/image
push/image: tag/image
	docker push $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: tag/image
tag/image: build/image
	docker tag $(IMAGE_NAME) $(IMAGE_REGISTRY)/$(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: build/image
build/image: build/rootfs.tar
	docker build -t $(IMAGE_NAME) $(BUILD_ARGS) .

build/rootfs.tar: build/build_image clean/build_container | build
	docker create --name $(BUILD_IMAGE_NAME) $(BUILD_IMAGE_NAME)
	docker export $(BUILD_IMAGE_NAME) > "$@"

build/build_image: Dockerfile.build | build
	# docker pull $(FROM_IMAGE_NAME):$(FROM_IMAGE_TAG)
	docker build -t $(BUILD_IMAGE_NAME) $(BUILD_ARGS) -f "$<" .

build:
	mkdir -p $@

.PHONY: clean/built_image
clean/built_image:
	-docker rmi $(IMAGE_NAME)

.PHONY: clean/build_image
clean/build_image:
	-docker rmi $(BUILD_IMAGE_NAME)

.PHONY: clean/build_container
clean/build_container:
	-docker rm $(BUILD_IMAGE_NAME)

.PHONY: clean
clean: clean/build_container clean/built_image clean/build_image
	rm -rf build
