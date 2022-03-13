#!/bin/sh
COMMAND="${1}"
if [ "${COMMAND}" == 'startd' ]; then
	/bitcoin/bin/bitcoind -datadir=/bitcoin/data "${OPTS}"
elif [ "${COMMAND}" == 'makeconf' ]; then
	cp /bitcoin/bitcoin.conf /bitcoin/data
	exit 0
# cli runs bitcoin-cli
# tx runs bitcoin-tx
# util runs bitcoin-util
# shell can be used for troubleshooting
elif [ "${COMMAND}" == 'shell' ]; then
	/bin/sh
else
	echo "Unknown command ${COMMAND}" 1>&2
	exit 1
fi
