alias icat="kitty +kitten icat --align left"

_dot_opts() {
	font="Input Mono"

	dot \
		-Ecolor=white \
		-Efontcolor=white \
		-Efontname="$font" \
		-Efontsize=18 \
		-Gbgcolor=black \
		-Gfontcolor=white \
		-Gfontname="$font" \
		-Gfontsize='28' \
		-Grankdir=LR \
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
	_dot_opts $* -Tpng \
	| convert \
			-trim \
			-bordercolor black \
			-border 20 \
			-transparent black \
			-resize '80%' \
			-channel RGB -negate \
			- "$1.png"
}
