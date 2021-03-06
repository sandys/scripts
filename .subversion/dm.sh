#!/bin/bash
DIFFMERGE_PATH=/usr/bin/
DIFFMERGE_EXEC=${DIFFMERGE_PATH}/diffmerge
# svn will invoke this with a bunch of arguments.  These are:
# $1 - path to the file that is the original
# $2 - path to the file that's the incoming merge version
# $3 - path to the file that's the latest from trunk (current working copy)
# $4 - path to where svn expects the merged output to be written
${DIFFMERGE_EXEC} --nosplash -m -t1="Remote"  -t2="Base & Final (merged)" -t3="Mine" -r="$4" "$2" "$1" "$3"
