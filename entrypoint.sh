#!/bin/sh
COMMAND="${1}"
if [ "${COMMAND}" == 'startd' ]; then
	/bitcoin/bin/bitcoind --datadir=/bitcoin/data "${OPTS}"
elif [ "${COMMAND}" == 'makeconf' ]; then
	cp /bitcoin/bitcoin.conf /bitcoin/data
	exit 0
elif [ "${COMMAND}" == 'cli' ]; then
	/bitcoin/bin/bitcoin-cli --datadir=/bitcoin/data "${OPTS}"
elif [ "${COMMAND}" == 'tx' ]; then
	/bitcoin/bin/bitcoin-tx --datadir=/bitcoin/data "${OPTS}"
elif [ "${COMMAND}" == 'util' ]; then
	/bitcoin/bin/bitcoin-util --datadir=/bitcoin/data "${OPTS}"
elif [ "${COMMAND}" == 'shell' ]; then	# Shell can be used to troubleshoot the container without having to exec into it
	/bin/sh
else
	echo "Unknown command ${COMMAND}" 1>&2
	exit 1
fi
