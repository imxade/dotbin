#!/bin/sh
pushd "${HOME}/.config/osnix" &&
su root -c "
cp /etc/nixos/hardware-configuration.nix . &&
nixos-rebuild switch --impure --flake .# --show-trace 
" &&
popd || exit
