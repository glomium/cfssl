FROM alpine:3.10.3
MAINTAINER Sebastian Braun <sebastian.braun@fh-aachen.de>
# base alpine template

ARG VERSION=1.4.1

RUN apk add --no-cache --virtual build-dependencies curl \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-bundle_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-bundle \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-certinfo_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-certinfo \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-newkey_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-newkey \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl-scan_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl-scan \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssljson_${VERSION}_linux_amd64 -o /usr/local/bin/cfssljson \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/cfssl_${VERSION}_linux_amd64 -o /usr/local/bin/cfssl \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/mkbundle_${VERSION}_linux_amd64 -o /usr/local/bin/mkbundle \
 && curl -sL https://github.com/cloudflare/cfssl/releases/download/v${VERSION}/multiroot_${VERSION}_linux_amd64 -o /usr/local/bin/multiroot \
 && chmod a+x /usr/local/bin/* \
 && apk del build-dependencies

WORKDIR /usr/src
VOLUME /usr/src/certs

COPY config.json /usr/src/

EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/cfssl", "serve", "-address=0.0.0.0", "-ca=/run/secrets/ca.pem", "-ca-key=/run/secrets/ca-key.pem", "-config=config.json"]
