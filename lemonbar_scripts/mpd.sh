#!/bin/bash

[ "$LEMONBAR_DIR" ] || {
	>&2 echo "You must set \$LEMONBAR_DIR before running this script"
	exit 1
}

cd $LEMONBAR_DIR
source lemonbar_common.sh
cd lemonbar_scripts

tmp_file="$LEMONBAR_TMP/mpd_data"
SHOWNAME_PATH=~/.cache/i3block-mpd-showname

showname=$([ -f $SHOWNAME_PATH ] && cat $SHOWNAME_PATH || echo 0)

exec-mpc() {
	mpc $* &> /dev/null
}

my_echo() {
	>$tmp_file echo $*
}

show_mpd() {
	output="%{A1:mpd_toggle:}%{A2:mpd_stop:}%{A3:mpd_showname:}%{A4:mpd_prev:}"
	output="$output%{A5:mpd_next:}"

	# non c'ho i caratteri unicode
	# playing=⏸
	#  paused=⏵
	# stopped=♪
	playing=" ▶"
	 paused=" ⏸"
	stopped=" ⏹"

	if [ $showname = '1' ]; then
		# come sopra
		# mpc current | awk -F ' - ' '{printf "【%s】", substr($2, 0, 20)}'
		output="$output$(mpc current | awk -F ' - ' '{printf "[ %s ]", $0}' | \
			tr -d '\r\n')"
	fi

	status=$(mpc status | sed -n 's/^\[\([^])]*\)\].*$/\1/p')
	case $status in
		playing) output="$output $playing" ;;
		paused)  output="$output $paused"  ;;
		*)       output="$output $stopped" ;;
	esac

	output="$output%{A}%{A}%{A}%{A}%{A}"

	echo $output >$tmp_file
	notify_change
}

[ $# -gt 0 ] && {
	case $1 in
		toggle) exec-mpc toggle ;;
		stop) exec-mpc stop ;;
		showname)
			showname=$((!$showname))
			echo $showname > $SHOWNAME_PATH ;;
		prev) exec-mpc prev ;;
		next) exec-mpc next ;;
	esac
	show_mpd
	exit 0
}

show_mpd
