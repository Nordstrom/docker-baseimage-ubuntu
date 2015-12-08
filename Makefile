container_registry := nordstrom
container_name := baseimage-ubuntu
container_release := 14.04.3

.PHONY: build tag release

build: Dockerfile $(build_container_prereqs)
	docker build -t $(container_name) .

tag: build
	docker tag $(container_name) $(container_registry)/$(container_name):$(container_release)

release: tag
	docker push $(container_registry)/$(container_name):$(container_release)
