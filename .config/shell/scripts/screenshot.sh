#!/bin/sh

mkdir "$HOME/box/ss"
#wayland
grim -g "$(slurp)" "$HOME/box/ss/screenshot_$(date '+%y%m%d-%H%M-%S').webp"
# Xorg
ffmpeg -f x11grab -i "$DISPLAY" -vf "crop=$(slop -f '%w:%h:%x:%y')" -vframes 1 -f image2 -vcodec png "$HOME/box/ss/screenshot_$(date '+%y%m%d-%H%M-%S').webp"
#- | xclip -selection clipboard -t image/png
# remove meta
exiftool -overwrite_original -all= "$HOME/box/ss"
