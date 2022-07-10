#!/bin/sh

mkdir ~/ss
# wayland
wf-recorder -a -g "$(slurp)" -f "$HOME/ss/screencast_$(date +%y%m%d-%H%M%S)".mkv & printf "$!" > /tmp/recordingpid
# Xorg
ffmpeg -f x11grab -i "$DISPLAY" -f alsa -i default -vf "crop=$(slop -f '%w:%h:%x:%y')" -qp 0 -r 30 "$HOME/ss/screencast_$(date '+%y%m%d-%H%M-%S').mkv" & printf "$!" > /tmp/recordingpid

