# bitcoincore-container
Bitcoin-Core container compiled to run in Alpine

ARGS:

VERSION can be set to any branch in the bitcoin-core github repo. Default is the master branch.
Older branches may have issues compiling or completing tests.

BIULDCORES is the number of cores used to compile the source code. Default is 4

This is still under development and the entrypoint script doesn't do anything ATM.
