#!/bin/sh

flatpak run com.brave.Browser

#--ozone-platform-hint=auto 
#--proxy-server="socks5://127.0.0.1:9050" --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE 127.0.0.1"
# --no-sandbox --user-data-dir=/tmp --use-gl=egl --js-flags=--jitless --disable-reading-from-canvas
# NetworkServiceSandbox,ForceIsolationInfoFrameOriginToTopLevelFrame # no google account
# --sync-url=0.0.0.0 --disable-sync-preferences
