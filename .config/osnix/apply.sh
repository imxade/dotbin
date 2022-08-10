#!/bin/sh
pushd "${HOME}/.config/osnix" || exit
su root -c "
cp /etc/nixos/hardware-configuration.nix . || exit 1
nixos-rebuild switch --flake .# --show-trace # --arg USER ${USER} other variables
reboot 
"
popd || exit
