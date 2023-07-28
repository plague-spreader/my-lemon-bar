[ "${LEMONBAR_TMP}" ] || LEMONBAR_TMP=/tmp/lemonbar_tmp

notify_change() {
	echo > "$LEMONBAR_TMP/lemonbar_notify"
}

[ -d "${LEMONBAR_TMP}" ] || mkdir -p "${LEMONBAR_TMP}"
