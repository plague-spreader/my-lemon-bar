#!/usr/bin/awk
/^MemTotal:/ {
	mem_total=$2
}
/^MemFree:/ {
	mem_free=$2
}
/^Buffers:/ {
	mem_free+=$2
}
/^Cached:/ {
	mem_free+=$2
}
/^SwapTotal:/ {
	swap_total=$2
}
/^SwapFree:/ {
	swap_free=$2
}
END {
	if (type == "SWAP") {
		free=swap_free/1024/1024
		used=(swap_total-swap_free)/1024/1024
		total=swap_total/1024/1024
	} else {
		free=mem_free/1024/1024
		used=(mem_total-mem_free)/1024/1024
		total=mem_total/1024/1024
	}

	pct=0
	if (total > 0) {
		pct=free/total
	}

	# color
	if (pct <= 0.5) {
		red = 255
		green = int(510*pct)
	} else {
		red = int(510*(1-pct))
		green = 255
	}
	blue = 0
	printf "%s: %%{F#%02X%02X%02X}%.1fG%%{F-}\n", type, red, green, blue,
		free
}
