#!/bin/sh

RELEASES_PATH=$1
KEEP_RELEASES=${2:-5}

[ ! -d $RELEASES_PATH ] && echo "$RELEASES_PATH is not found" && exit 1

CLEAN_COUNT=`ls $RELEASES_PATH 2>/dev/null | wc -l | xargs -i expr {} - $KEEP_RELEASES`

if [ $CLEAN_COUNT -gt 0 ]; then
  ls $RELEASES_PATH -t | tail -n $CLEAN_COUNT | xargs -i rm -r "$RELEASES_PATH/{}"
  echo "Cleaned up old releases"
else
  echo "It does not need to clean up"
fi