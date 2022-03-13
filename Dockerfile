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

FROM scratch
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
ENV HOME /bitcoin/data
EXPOSE 8333
COPY --from=builder /bitcoin/src/bitcoind /bitcoin/src/bitcoin-cli /bitcoin/src/bitcoin-tx /bitcoin/src/bitcoin-util /bin/
COPY --from=builder /lib/ld-musl-x86_64.so.1 /usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1 /lib/
CMD ["/bin/bitcoind"]
