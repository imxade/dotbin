#!/bin/sh

for i in firefox
	do 
		type "$i" && BROWSER="$i" && break
	done

firejail --whitelist="$XDG_RUNTIME_DIR" --whitelist="$HOME/ss" "$BROWSER"
