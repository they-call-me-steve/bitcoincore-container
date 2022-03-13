FROM alpine:3.13.5 as builder
MAINTAINER steve@the-steve.com
# Change VERSION any branch in git repo. Defaults to version master. Versions older than 23.x have trouble building.
ARG VERSION=master
# Default is 4, but change this to whatever works for your system
ARG BUILDCORES=4
# Download all needed packages, clone git repo and compile
RUN apk --update upgrade && \
    apk add gcc git make autoconf libtool automake pkgconfig g++ boost-dev libevent-dev db-dev && \
    rm -fr /var/cache/apk/* && \
    git clone https://github.com/bitcoin/bitcoin /bitcoin-core-src && \
    cd /bitcoin-core-src && \
    git checkout ${VERSION} && \
    ./autogen.sh && \
    ./configure && \
    make -j ${BUILDCORES} && \
    make check && \
    ./test/functional/test_runner.py --extended && \
    mkdir /bitcoin && cd src && cp bitcoind bitcoin-cli bitcoin-tx bitcoin-util /bitcoin

FROM alpine:3.13.5
MAINTAINER steve@the-steve.com
RUN apk --update upgrade && \
    apk add libtool pkgconfig boost-dev libevent-dev db-dev && \
    rm -fr /var/cache/apk/* && \
    mkdir -p /bitcoin/bin && \
    mkdir /bitcoin/data
COPY --from=builder /bitcoin/* /bitcoin/bin/
COPY entrypoint.sh /bitcoin/bin/
ENTRYPOINT ["/bin/sh"]
#ENTRYPOINT ["/bitcoin/bin/entrypoint.sh"]
#CMD ["startd"]
