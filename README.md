Bitcoin-Core container compiled to run in Alpine

ARGS:

VERSION - can be set to any branch in the bitcoin-core github repo. Default is the master branch.
Older branches may have issues compiling or completing tests.

BIULDCORES - is the number of cores used to compile the source code. Default is 4

To build run:
docker image build -t bitcoincore-container:v0.1 --build-arg BUILDCORES=16 .

Bitcoind can either be configured using options or by a configuration file.
To drop the default config into the data directory run:

NOTE: makeconf will delete any existing bitcoin.conf file. Do not run this twice.

doker run --rm -v /srv/bitcoind:/bitcoin/data bitcoincore-container:v0.1 makeconf

docker run -n bitcoincore -d -v /srv/bitcoin/:bitcoin/data bitcoincore-container:v0.1

To launch bitcoincore-container with options run:
docker run -n bitcoincore -d -v /srv/bitcoin/:/bitcoin/data bitcoincore-container:v01 bitcoind --prune=100000 

To see a list of all available commands run help:

docker run --rm -ti bitcoincore-container:v01 help

Port 8333 can be shared on a public IP address.

DO NOT SHARE PORT 8332 ON A PUBLIC IP. That could lead to stolen funds if you use the built in wallet with Bitcoin Core

/bitcoin/data is where all configurations and blockchaind data will be stored. For persistence you will need to mount this as a volume.
