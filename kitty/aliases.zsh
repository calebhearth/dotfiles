if command -v kitty 2>&1 > /dev/null; then
	alias ssh="kitty +kitten ssh"
fi

alias icat="kitty +kitten icat --align left"

_dot_opts() {
	font="Input Mono"

	# Dark mode
	# dot \
	#		-Ecolor="#3B0F4A" \
	#		-Efontcolor="#3B0F4A" \
	#		-Efontname="$font" \
	#		-Efontsize=18 \
	#		-Gbgcolor=none \
	#		-Gfontcolor="#3B0F4A" \
	#		-Gfontname="$font" \
	#		-Gfontsize='28' \
	#		-Grankdir=TB \
	#		-Ncolor="#3B0F4A" \
	#		-Nfontcolor="#3B0F4A" \
	#		-Nfontname="$font" \
	#		-Nfontsize='32' \
	#		-Nshape=rect \
	#		-Nstyle=rounded \
	#		-Nmargin=.25 \
	#		$*

	# light mode
	dot \
		-Ecolor=white \
		-Efontcolor=white \
		-Efontname="$font" \
		-Efontsize=18 \
		-Gbgcolor=none \
		-Gcolor=white \
		-Gfontcolor=white \
		-Gfontname="$font" \
		-Gfontsize='28' \
		-Grankdir=TB \
		-Ncolor=white \
		-Nfontcolor=white \
		-Nfontname="$font" \
		-Nfontsize='32' \
		-Nshape=rect \
		-Nstyle=rounded \
		-Nmargin=.25 \
		$*
}

idot() {
	_dot_opts $* -Tpng \
	| convert \
			-trim \
			-bordercolor black \
			-border 20 \
			-transparent black \
			-resize '80%' \
			- - \
	| icat
}

odot() {
	_dot_opts $* -Tsvg \
	| convert \
			-trim \
			-bordercolor black \
			-border 20 \
			-transparent black \
			-resize '80%' \
			-channel RGB -negate \
			- "$1.svg"
}
