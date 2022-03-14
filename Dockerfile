FROM alpine:3.13.5 as builder
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
# Change VERSION any branch in git repo. Defaults to master branch.
ARG VERSION=master
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=4
<<<<<<< HEAD
COPY makeconf.c /custom_coms/
COPY help.c /custom_coms/
RUN apk --update upgrade && \
    apk add autoconf automake bash bison build-base curl git libtool linux-headers make pkgconf python3 xz && \
    git clone --branch "${VERSION}" --single-branch https://github.com/bitcoin/bitcoin.git /bitcoin && \
    cd /bitcoin/ && \
    make -C depends/ -j "${BUILDCORES}" && \
    ./autogen.sh && \
    CONFIG_SITE=/bitcoin/depends/x86_64-pc-linux-musl/share/config.site ./configure --without-gui --without-miniupnpc --without-natpmp && \
    make -j "${BUILDCORES}" && \
    make check -j "${BUILDCORES}" && \
    cd /custom_coms && \
    gcc -o makeconf makeconf.c && \
    gcc -o help help.c

FROM scratch 
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
COPY --from=builder /bitcoin/share/examples/bitcoin.conf /bitcoin/
COPY --from=builder /custom_coms/makeconf /custom_coms/help /bitcoin/bin/
COPY --from=builder /bitcoin/src/bitcoind /bitcoin/src/bitcoin-cli /bitcoin/src/bitcoin-tx /bitcoin/src/bitcoin-util /bitcoin/src/bitcoin-wallet /bitcoin/bin/
COPY --from=builder /lib/ld-musl-x86_64.so.1 /usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1 /lib/
ADD symlink.tar /bitcoin/
EXPOSE 8333/tcp 8332/tcp
VOLUME ["/bitcoin/data"]
ENV HOME=/bitcoin PATH=/bitcoin/bin
CMD ["bitcoind"]
