FROM scratch
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

ENV DEBIAN_FRONTEND=noninteractive

# this is docker.io/library/ubuntu:16.04 minus some packages we don't need
ADD build/rootfs.tar /

USER nordstrom

CMD ["/bin/bash"]
