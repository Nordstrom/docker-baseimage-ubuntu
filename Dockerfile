FROM docker.io/library/ubuntu:16.04
MAINTAINER Store Modernization Platform Team "invcldtm@nordstrom.com"

RUN echo 'APT::Post-Invoke { "rm -f /var/lib/apt/lists/* /tmp/* /var/tmp/* || true"; };' > /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Clean "always";' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/baseimage-clean

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
 && apt-get upgrade -qy \
 && apt-get install -qy \
      apt-transport-https \
      ca-certificates \
      curl
