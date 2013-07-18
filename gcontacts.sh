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


fmt()
{
	_E=$1
	_N=$2
	_P=$3

	if [ -n "$(echo ${_E} | grep '@')" ]; then
		echo "${_E}	${_N}	${_P}"
	fi
}


fmt_line()
{
	while read line
	do
		NAME=$(echo ${line} | cut -d',' -f1)
		PHONE=$(echo ${line} | cut -d',' -f3)
		for EMAIL in $(echo ${line} | cut -d',' -f2 | tr -d ';')
		do
			fmt "${EMAIL}" "${NAME}" "${PHONE}"
		done
	done
}

fetch()
{
	_F=$1
	google contacts list ".*" --fields name,email,phone | fmt_line > ${_F}
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
