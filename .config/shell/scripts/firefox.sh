#!/bin/sh

for i in firefox
	do 
		type "$i" && BROWSER="$i" && break
	done

for i in firejail
	do 
		type "$i" && JAIL="$i --whitelist=$XDG_CONFIG_HOME" && break
	done

tor-browser ||
eval "$JAIL $BROWSER --profile $XDG_CONFIG_HOME/fox"

