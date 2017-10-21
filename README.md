# docker-baseimage-ubuntu

Nordstrom's Ubuntu-derived Docker baseimage. This is based on [`ubuntu-slim`](https://github.com/kubernetes/ingress-nginx/tree/master/images/ubuntu-slim), with a few additions.

The images produced from this repo are published to `quay.io/nordstrom/baseimage-ubuntu`. We intend to publish a tag for each long-term support (LTS) release of Ubuntu[1]. We will probably only actively maintain images for a single LTS release at a time (so far, just `16.04`).

[1] Yes, this means that we overwrite the tag value when updating. Maintaining fine-grained versioning in the `FROM` of a Dockerfile is a significant hassle (which would be necessary if we used immutable tags), so mutating the tag value is a compromise.
