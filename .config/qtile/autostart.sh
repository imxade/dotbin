#!/bin/sh

export \
	NO_AT_BRIDGE=1 \
	ELM_SCALE=1.5 \
	ELM_ENGINE=wayland_egl \
	GDK_SCALE=2 \
	GDK_DPI_SCALE=1 \
	GDK_BACKEND=wayland \
	MOZ_ENABLE_WAYLAND=1 \
	WLR_BACKENDS=headless \
	CLUTTER_BACKEND=wayland \
	SDL_VIDEODRIVER=wayland \
	CLUTTER_BACKEND=wayland \
	QT_QPA_PLATFORM=wayland-egl \
	QT_AUTO_SCREEN_SCALE_FACTOR=1 \
	ECORE_EVAS_ENGINE=wayland-eglexport
# gammastep -PO 2000 &
sh "${XDG_CONFIG_HOME}"/shell/scripts/display/run.sh &
sh "${XDG_CONFIG_HOME}"/shell/scripts/display/apply.sh &
"$HOME/.config/shell/scripts/chrome.sh" ||
"$HOME/.config/shell/scripts/firefox.sh" ||
qutebrowser --qt-flag enable-gpu-rasterization &
