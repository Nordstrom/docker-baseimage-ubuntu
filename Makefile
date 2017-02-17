image_name := baseimage-ubuntu
image_registry := quay.io/nordstrom
image_release := 16.04
build_image := $(image_name)-build

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
	docker build -t $(build_image) $(build_args) -f Dockerfile.build .
	docker create --name $(build_image) $(build_image)
	docker export $(build_image) > "$@"

build:
	mkdir -p $@

clean:
	docker rm $(build_image)
	rm -rf build
