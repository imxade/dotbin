#!/bin/sh

export SDL_VIDEODRIVER=wayland
export WLR_BACKENDS=headless
gammastep -PO 2000 &
firefox --profile "$HOME/.config/fox" ||
"$HOME/.config/shell/scripts/chrome.sh" ||
qutebrowser --qt-flag enable-gpu-rasterization &
