FROM scratch
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

# this is docker.io/library/ubuntu:16.04 minus some packages we don't need
ADD build/rootfs.tar /

CMD ["/bin/bash"]
