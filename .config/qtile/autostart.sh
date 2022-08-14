#!/bin/sh

export SDL_VIDEODRIVER=wayland
export WLR_BACKENDS=headless
gammastep -PO 2000 &
"$HOME/.config/shell/scripts/chrome.sh" ||
"$HOME/.config/shell/scripts/firefox.sh" ||
qutebrowser --qt-flag enable-gpu-rasterization &
