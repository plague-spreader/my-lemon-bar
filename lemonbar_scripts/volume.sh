#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/volume_data"

[ $# -gt 0 ] && {
	case $1 in
		toggle) pamixer -t  ; notify_change; ;;
		raise)  pamixer -i 5; notify_change; ;;
		lower)  pamixer -d 4; notify_change; ;;
	esac
}

read_volume() {
	output="%{A3:vol_toggle:}%{A4:vol_raise:}%{A5:vol_lower:}"
	output="${output}VOL: $(pamixer --get-volume-human | tr -d '\r\n')"
	output="${output} %{A}%{A}%{A}"
	echo $output > $tmp_file
	notify_change
}

read_volume
