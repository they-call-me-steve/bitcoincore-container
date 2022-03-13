# bitcoincore-container
Bitcoin-Core container compiled to run in Alpine

ARGS:

VERSION can be set to any branch in the bitcoin-core github repo. Default is the master branch.
Older branches may have issues compiling or completing tests.

BIULDCORES is the number of cores used to compile the source code. Default is 4

This is still under development.

To build run:

docker image build -t bitcoincore-container:v1 .

Bitcoind can either be configured using the OPTS environment variable or by a configuration file.
To drop the default config into the data directory run:

doker run --rm --user bitcoin -v /srv/bitcoind:/bitcoin/data bitcoincore-container:v1 makeconf

docker run -n bitcoincore --user bitcoin -v /srv/bitcoind/:bitcoin/data bitcoincore-container:v1

To launch bitcoincore-container with options run:
docker run -n bitcoincore --user bitcoin -v /home/bitcoin/data:/bitcoin/data -E OPTS="--prune=100000"

Port 8333 can be shared on a public IP address.

DO NOT SHARE PORT 8332 ON A PUBLIC IP. That could lead to stolen funds if you use the built in wallet with Bitcoin Core
