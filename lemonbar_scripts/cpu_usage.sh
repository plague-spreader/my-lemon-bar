#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/cpu_data"

read_cpu() {
	>$tmp_file ./cpu_usage.pl | tr -d '\r\n'
	notify_change
}

[ $# -gt 0 ] && {
	read_cpu
	exit 0
}

while true; do
	read_cpu
	sleep 30;
done
