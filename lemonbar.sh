#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh

lemonbar_in() {
	while read; do
		case $REPLY in
			mpd_*) lemonbar_scripts/mpd.sh ${REPLY#mpd_} ;;
			date_*) lemonbar_scripts/date.sh notify ;;
			temperature_*) lemonbar_scripts/temperature.sh notify ;;
			cpu_*) lemonbar_scripts/cpu_usage.sh notify ;;
			mem_ram_*) lemonbar_scripts/memory.sh notify ;;
			mem_swap_*) lemonbar_scripts/memory_swap.sh notify ;;
			disk_*) lemonbar_scripts/disk.sh notify ;;
			touchpad_*) lemonbar_scripts/touchpad.sh ${REPLY#touchpad_} ;;
			vol_*) lemonbar_scripts/volume.sh ${REPLY#vol_} ;;
			*) true ;;
		esac
	done
}

lemonbar_out() {
	# in the associative array "data" you have to setup all the scripts you
	# want to run. The array keys will this script where to look for the data
	# (see line 58)
	declare -A data
	data[mpd]="./mpd.sh"
	data[temperature]="./temperature.sh"
	data[cpu]="./cpu_usage.sh"
	data[mem_ram]="./memory.sh"
	data[mem_swap]="./memory_swap.sh"
	data[disk]="./disk.sh"
	data[touchpad]="./touchpad.sh"
	data[volume]="./volume.sh"

	# run all scripts before launching the lemonbar
	cd lemonbar_scripts
		for script in ${!data[*]}; do
			${data[$script]} &
			data[$script]=""
		done
	cd ..
	jobs -p > "${LEMONBAR_TMP}/jobs"

	while true; do
		# wait for something to change...
		cat "$LEMONBAR_TMP/lemonbar_notify" < /dev/null

		# something has changed, read everything
		# can be improved to read only what's changed
		for script in ${!data[*]}; do
			data[$script]=$(cat "$LEMONBAR_TMP/${script}_data" | tr -d '\r\n')
		done

		# show the newly got data
		out="%{l}${data[temperature]} | ${data[cpu]} | ${data[mem_ram]} | "
		out="$out${data[mem_swap]} | ${data[disk]} | ${data[touchpad]} | "
		out="$out${data[volume]}%{r}${data[mpd]}"
		echo "$out"
	done
}

the_lemonbar() {
	# setup your own params here
	common_params="-a20"
	pipes=()
	i=1
	while read offset; do
		pipe="$LEMONBAR_TMP/lemonbar_pipe.$((i++))"
		mkfifo "$pipe"
		pipes+=("$pipe")
		# maybe you wanna change the geometry settings according to your
		# screen resolution ...
		lemonbar -g 1920x23$offset $common_params < "$pipe" &
	done < <(xrandr | grep -oE '\+[0-9]+\+[0-9]+')
	eval "tee ${pipes[*]} >/dev/null"
}

quit_lemonbar() {
	while read pidjob; do
		kill $pidjob
	done < "${LEMONBAR_TMP}/jobs"
	rm "${LEMONBAR_TMP}/"*
	exit 0
}

mkdir -p "${LEMONBAR_TMP}"

mkfifo "${LEMONBAR_TMP}/lemonbar_notify" &>/dev/null

[ "$1" = "test" ] && {
	lemonbar_out
	exit 0
}

trap quit_lemonbar SIGINT SIGTERM

lemonbar_out | the_lemonbar | lemonbar_in
