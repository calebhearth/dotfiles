#!/bin/bash
# Copyright 2012 The Go Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# support functions for go cross compilation

type setopt >/dev/null 2>&1 && setopt shwordsplit
PLATFORMS="darwin/386 darwin/amd64 freebsd/386 freebsd/amd64 freebsd/arm linux/386 linux/amd64 linux/arm windows/386 windows/amd64 openbsd/386 openbsd/amd64"

function go-build-all {
	rm dist/ftree-*
	local FAILURES=""
	for PLATFORM in $PLATFORMS; do
		local GOOS=${PLATFORM%/*}
		local GOARCH=${PLATFORM#*/}
		local SRCFILENAME=`echo $@ | sed 's/\.go//'`
		local CURDIRNAME=${PWD##*/}
		local OUTPUT="${SRCFILENAME:-$CURDIRNAME}-${GOOS}-${GOARCH}" # if no src file given, use current dir name
		local CMD="env GOOS=$GOOS GOARCH=$GOARCH go build -o dist/$OUTPUT"
		echo "$CMD"
		$CMD || (FAILURES="$FAILURES $PLATFORM" && continue)
		local SIGN="gpg2 --detach-sign dist/$OUTPUT"
		echo "$SIGN"
		$SIGN || (FAILURES="$FAILURES gpg:$PLATFORM" && continue)
		local SUM="shasum --algorithm=256 $OUTPUT"
		echo "$SUM"
		$( cd dist/ && $SUM > $OUTPUT.sha256 || (FAILURES="$FAILURES sha:$PLATFORM" && continue))
	done
	if [ "$FAILURES" != "" ]; then
			echo "*** go-build-all FAILED on $FAILURES ***"
			return 1
	fi
}
