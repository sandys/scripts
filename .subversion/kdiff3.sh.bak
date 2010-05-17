#!/bin/bash
KDIFF3_PATH=/usr/bin/
KDIFF3_EXEC=${KDIFF3_PATH}/kdiff3
# svn will invoke this with a bunch of arguments.  These are:
# $1 - path to the file that is the original
# $2 - path to the file that's the incoming merge version
# $3 - path to the file that's the latest from trunk (current working copy)
# $4 - path to where svn expects the merged output to be written
${KDIFF3_EXEC} -m --L1 "Remote"  --L2 "Base" --L3 "Mine" -o "$4" "$2" "$1" "$3" 
