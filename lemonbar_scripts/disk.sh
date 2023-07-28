#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/disk_data"

read_disk() {
	output="%{A1:disk_notify:}"
	output="$output$(df -h YOURDEVICEPATH | awk '
	/nvme0n1p3/ {
		free = $4
		pct = 1 - $5/100

		if (pct <= 0.5) {
			red = 255
			green = int(510*pct)
		} else {
			red = int(510*(1-pct))
			green = 255
		}
		blue = 0
		printf "DISK: %%{F#%02X%02X%02X}%dG%%{F-}\n", red, green, blue, free
	}')"
	output="$output%{A}"

	echo $output > $tmp_file
	notify_change
}

[ $# -gt 0 ] && {
	read_disk
	exit 0
}

while true; do
	read_disk
	sleep 30
done
