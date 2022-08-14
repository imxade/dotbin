#!/bin/sh

for i in firefox librefox
	do 
		type "$i" && BROWSER="$i" && break
	done

for i in firejail
	do 
		type "$i" && JAIL="$i" && break
	done

eval "$JAIL $BROWSER" --profile "$HOME/.config/fox"
