image_name := baseimage-ubuntu
image_registry := quay.io/nordstrom
image_release := 16.04
from_image_name := docker.io/library/ubuntu
from_image_tag := 16.04
build_image_name := $(image_name)-build

ifdef http_proxy
build_args := --build-arg http_proxy=$(http_proxy)
build_args += --build-arg https_proxy=$(http_proxy)
endif

.PHONY: build/build-image build/image tag/image push/image

push/image: tag/image
	docker push $(image_registry)/$(image_name):$(image_release)

tag/image: build/image
	docker tag $(image_name) $(image_registry)/$(image_name):$(image_release)

build/image: build/Dockerfile build/rootfs.tar
	docker build -t $(image_name) $(build_args) -f "$<" build

build/Dockerfile: Dockerfile | build
	cp $< $@

build/rootfs.tar: Dockerfile.build | build
	docker pull $(from_image_name):$(from_image_tag)
	docker build -t $(build_image_name) $(build_args) -f Dockerfile.build .
	docker create --name $(build_image_name) $(build_image_name)
	docker export $(build_image_name) > "$@"

build:
	mkdir -p $@

clean/built_image:
	-docker rmi $(image_name)

clean/build_image:
	-docker rmi $(build_image_name)

clean/build_container:
	-docker rm $(build_image_name)

clean: clean/build_container clean/built_image clean/build_image
	rm -rf build
