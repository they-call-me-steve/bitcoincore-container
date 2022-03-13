FROM alpine:3.13.5 as builder
MAINTAINER steve@the-steve.com
# Change VERSION any branch in the bitcoin git repo. Defaults to master. Versions older than 23.x may have trouble building or completing tests.
ARG VERSION=master
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=4
# Download all needed packages, clone git repo, compile, run tests to verify success, move binaries to directory for easy copy
RUN apk --update upgrade && \
    apk add gcc git make autoconf libtool automake pkgconfig g++ boost-dev libevent-dev db-dev libzmq file && \
    rm -fr /var/cache/apk/* && \
    git clone https://github.com/bitcoin/bitcoin /bitcoin-core-src && \
    cd /bitcoin-core-src && \
    git checkout ${VERSION} && \
    ./autogen.sh && \
    ./configure --with-incompatible-bdb && \
    make -j ${BUILDCORES} && \
    make check && \
    ./test/functional/test_runner.py --extended && \
    mkdir /bitcoin && cd src && cp bitcoind bitcoin-cli bitcoin-tx bitcoin-util /bitcoin

FROM alpine:3.13.5
MAINTAINER steve@the-steve.com
RUN apk --update upgrade && \
    rm -fr /var/cache/apk/* && \
    mkdir -p /bitcoin/bin && \
    mkdir /bitcoin/data
# Copy all needed files from builder
COPY --from=builder /bitcoin/* /bitcoin/bin/
COPY --from=builder /bitcoin-core-src/share/examples/bitcoin.conf /bitcoin/
COPY --from=builder  /usr/lib/libevent* /usr/lib/libstdc++.so.6* /usr/lib/libgcc_s.so* /usr/lib/libdb_cxx-5.3.so* /usr/lib/
COPY entrypoint.sh /bitcoin/bin/
RUN adduser -h /bitcoin -D bitcoin && \
    chown -R bitcoin. /bitcoin 

EXPOSE 8333/tcp 8332/tcp
VOLUME ["/bitcoin/data"]
ENTRYPOINT ["/bitcoin/bin/entrypoint.sh"]
CMD ["startd"]
