#!/bin/sh

flatpak run org.mozilla.firefox ||
firejail --ignore=dbus-system --whitelist="$HOME/box" --whitelist="$HOME/.asoundrc" firefox ||
firefox

