#!/bin/sh

for i in firefox
	do 
		type "$i" && BROWSER="$i" && break
	done

firejail --whitelist="$HOME/box" --whitelist="$HOME/.asoundrc" "$BROWSER"
