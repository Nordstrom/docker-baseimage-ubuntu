# this is docker.io/library/ubuntu:17.04 minus some packages we don't need
FROM scratch
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

ADD rootfs.tar /

CMD ["/bin/bash"]
