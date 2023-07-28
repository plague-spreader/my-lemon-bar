#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/temperature_data"

read_temperature() {
	echo "%{A1:temperature_notify:}TEMP: $(sensors | grep -A3 acpitz | \
		awk '/temp1/ {print $2}')%{A}" > $tmp_file
	notify_change
}

[ $# -gt 0 ] && {
	read_temperature
	exit 0
}

while true; do
	read_temperature
	sleep 30
done
