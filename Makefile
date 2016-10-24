image_name := baseimage-ubuntu
image_registry := quay.io/nordstrom
image_release := 16.04
build_image ?= baseimage-ubuntu-build
tar_file ?= rootfs.tar
proxy_url := http://webproxysea.nordstrom.net:8181
build_args ?= --build-arg http_proxy=$(proxy_url) --build-arg https_proxy=$(proxy_url)

.PHONY: build/build-image build/image tag/image push/image

build/build-image: Dockerfile.build $(build_image_prereqs)
	rm -f $(tar_file)
	
	#get nordstrom issuing ca certs from the keychain to inject into the base image (this will only work on a mac)
	mkdir -p ./certs
	rm -rf ./certs/*
	security find-certificate -a -c "Nordstrom Issuing" | grep \"alis\" | sed -E -e "s/.*<blob>=\"(.*)\"/\"\1\"/" | xargs -I % sh -c "security find-certificate -c '%' -p > './certs/%.crt'"
	
	docker build -t $(build_image) $(build_args) -f Dockerfile.build .
	docker create --name $(build_image) $(build_image)
	docker export $(build_image) > $(tar_file)
	docker rm $(build_image)

build/image: Dockerfile build/build-image $(build_image_prereqs)
	docker build -t $(image_name) $(build_args) .
	docker build -t $(image_name) .

tag/image: build/image
	docker tag $(image_name) $(image_registry)/$(image_name):$(image_release)

push/image: tag/image
	docker push $(image_registry)/$(image_name):$(image_release)

