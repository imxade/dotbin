#!/bin/sh

for i in firefox
	do 
		type "$i" && BROWSER="$i" && break
	done

firejail --ignore=dbus-system --whitelist="$HOME/box" --whitelist="$HOME/.asoundrc" "$BROWSER"

