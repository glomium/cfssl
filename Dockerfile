# vim:set ft=dockerfile:
ARG BASEIMAGE=ubuntu:rolling
FROM $BASEIMAGE as build

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

ARG VERSION=1.6.0

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    build-essential \
    ca-certificates \
    curl \
    git \
    golang-go \
 && curl -sL https://github.com/cloudflare/cfssl/archive/v${VERSION}.tar.gz -o /opt/cfssl.tar.gz \
 && mkdir /opt/cfssl \
 && tar xzvf /opt/cfssl.tar.gz -C /opt/cfssl --strip-components=1 \
 && cd /opt/cfssl \
 && make \
 && chmod a+x bin/*

FROM $BASEIMAGE
MAINTAINER Sebastian Braun <sebastian.braun@fh-aachen.de>

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    ca-certificates \
    curl \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

COPY --from=build /opt/cfssl/bin/* /usr/local/bin/

WORKDIR /usr/src
VOLUME /usr/src/certs

COPY config.json /usr/src/

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/cfssl", "serve", "-address=0.0.0.0", "-ca=/run/secrets/ca.crt", "-ca-key=/run/secrets/ca.key", "-config=config.json"]
