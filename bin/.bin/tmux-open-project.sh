#!/bin/bash

# check number of argument

usage() {
	print "need an argument"
	print "$0 (prev|session_name)"
	exit 1
}

if [ "$#" != "1" ]; then
	usage
fi

SESSION_NAME=${1}

case "${1}" in
prev) ;;
*)
	# check if the session is already active
	tmux list-sessions | grep "$SESSION_NAME" >/dev/null
	if [ "$?" == "0" ]; then

	fi
	;;
esac
