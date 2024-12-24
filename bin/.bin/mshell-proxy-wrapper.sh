#!/bin/bash

TMPFILE=$(mktemp)

touch "$TMPFILE"

function start() {
	echo "starting"
	sudo /opt/homebrew/bin/mshell proxy >"$TMPFILE" 2>&1
}

function stop() {
	echo "STOPPING"
	kill $$
}

trap stop SIGINT SIGTERM

function parse() {
	tail -f "$TMPFILE" | while read -r line; do
		echo "$line"
		if echo "$line" | grep -q "To sign in, use a web browser to open the page"; then
			CODE=$(echo "$line" | sed -e 's/.*enter the code \([A-Z0-9]*\).*/\1/')
			# WEBSITE=$(echo "$line" | sed -e 's/.*\(http[a-z\.\/]+\) .*/\1/')
			WEBSITE=$(echo "$line" | cut -d" " -f12)
			echo "$CODE" | pbcopy
			echo "code copied in clipboard, opening ${WEBSITE}"
			open "$WEBSITE"
		fi
	done
}

parse &

# start the proxy
timeout 1h <(start)
