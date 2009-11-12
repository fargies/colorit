#!/bin/bash

CURR_PATH=$(cd $(dirname $0) ; pwd)
[ -n "$abs_top_builddir" ] || abs_top_builddir=$CURR_PATH/..

. ${CURR_PATH}/utils.sh

TMPDIR=$(mktemp)

echo 'libtool: install: warning: remember to run \`libtool --finish /home/fargie_s/work/colorit/colorit-1.0.0/_inst/lib' | ${abs_top_builddir}/src/colorit > $TMPDIR

awk '/\033\[1\;33mwarning:/ { exit 1 }' $TMPDIR && die "FAILED: libtool install warning not highlighted"

rm $TMPDIR

exit 0

