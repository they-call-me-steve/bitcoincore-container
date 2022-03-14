FROM alpine:3.13.5 as builder
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
# Change VERSION any branch in git repo. Defaults to master branch.
ARG VERSION=master
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=20
RUN apk --update upgrade && \
    apk add autoconf automake bash bison build-base curl git libtool linux-headers make pkgconf python3 xz && \
    git clone --branch "${VERSION}" --single-branch https://github.com/bitcoin/bitcoin.git /bitcoin && \
    cd /bitcoin/ && \
    make -C depends/ -j "${BUILDCORES}" && \
    ./autogen.sh && \
    CONFIG_SITE=/bitcoin/depends/x86_64-pc-linux-musl/share/config.site ./configure --without-gui --without-miniupnpc --without-natpmp && \
    make -j "${BUILDCORES}" && \
    make check -j "${BUILDCORES}"

FROM alpine:3.13.5
LABEL MAINTAINER "Stephen Hunter" <steve@the-steve.com>
EXPOSE 8333/tcp 8332/tcp
COPY --from=builder /bitcoin/share/examples/bitcoin.conf /bitcoin/
COPY --from=builder /bitcoin/src/bitcoind /bitcoin/src/bitcoin-cli /bitcoin/src/bitcoin-tx /bitcoin/src/bitcoin-util /bitcoin/src/bitcoin-wallet /bitcoin//bin/
COPY --from=builder /lib/ld-musl-x86_64.so.1 /usr/lib/libstdc++.so.6 /usr/lib/libgcc_s.so.1 /lib/
COPY entrypoint.sh /bitcoin/bin
VOLUME ["/bitcoin/data"]
RUN ln -s /bitcoin/data /bitcoin/.bitcoin
ENV HOME=/bitcoin
WORKDIR /bitcoin/bin
ENTRYPOINT ["./entrypoint.sh"]
