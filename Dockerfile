FROM alpine:3.13.5 as builder
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
# Change VERSION any branch in git repo. Defaults to version 23.x
ARG VERSION=22.x
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=4
RUN apk add -U autoconf automake bash bison boost-dev build-base curl db-dev git libevent-dev libtool linux-headers make pkgconf python3 xz && \
    git clone --branch "${VERSION}" --single-branch https://github.com/bitcoin/bitcoin.git /bitcoin && \
    cd /bitcoin/ && \
    make -C depends/ -j "${BUILDCORES}" && \
    ./autogen.sh && \
    CONFIG_SITE=/bitcoin/depends/x86_64-pc-linux-musl/share/config.site ./configure --without-gui --without-miniupnpc --without-natpmp && \
    make -j "${BUILDCORES}"

FROM alpine:3.13.5
MAINTAINER steve@the-steve.com
ENV HOME /bitcoin/data
EXPOSE 8333
RUN apk --update upgrade && \
    apk add libtool pkgconfig boost-dev libevent-dev db-dev && \
    rm -fr /var/cache/apk/* && \
    mkdir -p /bitcoin && \
    mkdir /bitcoin/data
COPY --from=builder /bitcoin/* /bitcoin/bin/
COPY entrypoint.sh /bitcoin/bin/
ENTRYPOINT ["/bin/sh"]
#ENTRYPOINT ["/bitcoin/bin/entrypoint.sh"]
#CMD ["startd"]
