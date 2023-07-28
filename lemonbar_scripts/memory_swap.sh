#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/mem_swap_data"

read_mem() {
	output="%{A1:mem_swap_notify:}"
	#output=""
	output="$output$(awk -v type=SWAP -f ./memory.awk /proc/meminfo\
		| tr -d '\r\n')"
	output="$output%{A}"
	>$tmp_file echo $output
	notify_change
}

[ $# -gt 0 ] && {
	read_mem
	exit 0
}

while true; do
	read_mem
	sleep 30
done
