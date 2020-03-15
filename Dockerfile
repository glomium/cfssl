ARG UBUNTU=rolling
FROM ubuntu:$UBUNTU
MAINTAINER Sebastian Braun <sebastian.braun@fh-aachen.de>

ARG VERSION=1.4.1

RUN apt-get update && apt-get install --no-install-recommends -y -q \
    ca-certificates \
    curl \
 && apt-get clean \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-bundle_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-bundle \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-certinfo_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-certinfo \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-newkey_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-newkey \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-scan_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-scan \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssljson_${VERSION}_linux_amd64 -o /usr/local/bin/cfssljson \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/mkbundle_${VERSION}_linux_amd64 -o /usr/local/bin/mkbundle \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/multiroot_${VERSION}_linux_amd64 -o /usr/local/bin/multiroot \
 && chmod a+x /usr/local/bin/* \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src
VOLUME /usr/src/certs

COPY config.json /usr/src/

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/cfssl", "serve", "-address=0.0.0.0", "-ca=/run/secrets/ca.crt", "-ca-key=/run/secrets/ca.key", "-config=config.json"]
