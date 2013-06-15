#!/bin/sh

usage()
{
	echo "Usage: $0 <command>"
	echo "Commands :"
	echo "	list <regex> : list all contact matching regexp"
	echo "	fetch : fetch contacts and store it into cache"
}

list()
{
	_F=$1
	shift

	echo "Google contact search result :"

	if [ ! -f ${_F} ]; then
		fetch ${_F}
	fi

	grep -i -e "$@" ${_F}

}

fetch()
{
	_F=$1
	google contacts list ".*" --fields name,email,phone |		\
	       sed "s/\([^,]*\),\([^,]*\),\([^,]*\)/\2	\1	\3/" |	\
	       grep -v -e "^None" > ${_F}
}

PROGNAME=$0
BOOKCACHE="/home/repk/.mutt/scripts/.gcontacts"

if [ $# -lt 1 ]; then
	usage ${PROGNAME}
	exit -1
fi

if [ "$1" == "list" ]; then
	if [ $# -lt 2 ]; then
		usage ${PROGNAME}
		exit -1
	fi
	shift
	list ${BOOKCACHE} $@
elif [ "$1" == "fetch" ]; then
	if [ $# -ne 1 ]; then
		usage ${PROGNAME}
		exit -1
	fi
	shift
	fetch ${BOOKCACHE}
fi
