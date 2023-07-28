#! /bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/touchpad_data"

read_touchpad() {
	synout=$(synclient | tr '\n' ';')
	is_inactive_touchpad=$(echo $synout |\
		awk 'BEGIN {RS=";"} /TouchpadOff/ {print $3}')
	is_active_horiz=$(echo $synout |\
		awk 'BEGIN {RS=";"} /HorizTwoFingerScroll/ {print $3}')

	output="%{A1:touchpad_toggle:}TOUCHPAD"
	if [ "$is_active_horiz" = 1 ]
	then
		output="$output w/HOR SCROLL"
	fi
	if [ "$is_inactive_touchpad" = 0 ]
	then
		output="$output: ON"
	else
		output="$output: OFF"
	fi
	output="$output%{A}"

	echo $output > $tmp_file
	notify_change
}

[ "$1" = toggle ] && {
	synclient TouchpadOff=$((1-$(synclient | awk '/TouchpadOff/ {print $3}')))
}

read_touchpad
