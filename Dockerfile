# this is docker.io/library/ubuntu:16.04 minus some packages we don't need
FROM scratch
MAINTAINER Store Modernization Platform Team "invcldtm@nordstrom.com"

ADD rootfs.tar /

CMD ["/bin/bash"]
