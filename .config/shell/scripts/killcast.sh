#!/bin/sh
recpid="$(cat /tmp/recordingpid)" && kill -15 "$recpid" && rm -f /tmp/recordingpid && sleep 2 && kill -9 "$recpid"
# remove meta
exiftool -overwrite_original -all= "$HOME/ss"
