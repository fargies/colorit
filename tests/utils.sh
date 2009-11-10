

function die {
  if [ "$#" -ge 1 ]; then
    echo "$@" >&2
  fi
  [ -e "$TMPDIR" ] && rm "$TMPDIR"
  exit 1
}

