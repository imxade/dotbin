#!/bin/sh

for i in firefox
	do 
		type "$i" && BROWSER="$i" && break
	done

firejail --profile='/home/x/.mozilla/firejail/firefox.profile' --whitelist="$HOME/box" --whitelist="$HOME/.asoundrc" --whitelist="/dev/hidraw0" "$BROWSER"

