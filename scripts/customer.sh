#!/bin/bash

rm -rf /tmp/customer
ENV=$1
CHECKS=0
DEFS=0
git clone https://github.com/danielschlieder/customer.git /tmp/customer >/dev/null 2>&1
PENV="/tmp/customer/$ENV"
if [[ -e "$PENV" ]]; then
	echo >&2
	echo "Found checks supplied by the customer for environment $ENV" >&2
	echo >&2
	if [[ -e "$PENV/checks" ]]; then
		echo >&2
		echo "Copying checks" >&2
		echo >&2
		cp -arv $PENV/checks/* /usr/lib/nagios/plugins
		CHECKS=1
	fi 
	if [[ -e "$PENV/defs" ]]; then
		DEFS=1
		echo >&2
		echo "Copying check definition" >&2
		echo >&2
		mkdir -p /usr/share/icinga2/include/plugins-$ENV
		cp -arv $PENV/defs/* /usr/share/icinga2/include/plugins-$ENV
		echo >&2
		echo "Enabling new check definition" >&2
		echo >&2
		echo "include <plugins-$ENV>" >> /etc/icinga2/icinga2.conf
	else
		if [[ "$CHECKS" == "1" ]]; then
			echo "Customer supplied checks without a definition! Please supply the definition in the /defs folder" >&2
			exit 1
		fi
	fi
fi 
