FROM ubuntu-debootstrap:14.04.3
MAINTAINER Innovation Platform Team "invcldtm@nordstrom.com"

# I copied this from the docker/registry:2.2.0 image's history
# The last 5 lines configure Dpkg & APT to never fill and/or clear their caches post-install
# I don't know what the first several lines of this do.
RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d \
 && echo 'exit 101' >> /usr/sbin/policy-rc.d \
 && chmod +x /usr/sbin/policy-rc.d  \
 && dpkg-divert --local --rename --add /sbin/initctl \
 && cp -a /usr/sbin/policy-rc.d /sbin/initctl \
 && sed -i 's/^exit.*/exit 0/' /sbin/initctl \
 && echo 'force-unsafe-io' > /etc/dpkg/dpkg.cfg.d/baseimage-apt-speedup \
 && echo 'DPkg::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' > /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Update::Post-Invoke { "rm -f /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin || true"; };' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'Dir::Cache::pkgcache ""; Dir::Cache::srcpkgcache "";' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/baseimage-no-languages \
 && echo 'Acquire::GzipIndexes "true"; Acquire::CompressionTypes::Order:: "gz";' > /etc/apt/apt.conf.d/baseimage-gzip-indexes \
 && echo 'APT::Post-Invoke { "rm -f /var/lib/apt/lists/* /tmp/* /var/tmp/* || true"; };' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Clean "always";' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Install-Recommends "false";' >> /etc/apt/apt.conf.d/baseimage-clean \
 && echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/baseimage-clean

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
 && apt-get install -qy \
      apt-transport-https \
      ca-certificates
