#!/bin/sh
# OPTS environment variable is used to pass options to the application
# bitcoind can be configured either through options or through a bitcoin.conf file put in place by makeconf
# if no command is provied bitcoind will be launched
COMMAND="${1}"
if [ -z "${COMMAND}" ]; then
	/bitcoin/bin/bitcoind
fi
if [ "${COMMAND}" == 'makeconf' ]; then
	cp /bitcoin/bitcoin.conf /bitcoin/data
	exit 0
elif ls /bitcoin/bin | grep -q "${COMMAND}"; then
	/bitcoin/bin/"${@}"
elif [ "${COMMAND}" == 'shell' ]; then	# Shell can be used to troubleshoot the container without having to exec into it
	/bin/sh
elif [ "${COMMAND}" == 'help' ]; then
	echo -e "Container commands:\n\tbitcoin-cli\n\tbitcoin-tx\n\tbitcoin-util\n\tbitcoin-wallet\n\tbitcoind\n\tmakeconf\n\tshell\n\thelp"
	exit 0
else
	echo "Unknown command ${COMMAND}" 1>&2
	exit 1
fi
