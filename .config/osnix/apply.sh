#!/bin/sh
pushd "${HOME}/.config/osnix" &&
sudo su root -c "
cp /etc/nixos/hardware-configuration.nix . && 
nixos-rebuild switch --impure --flake .#nixos --show-trace --option sandbox false

" &&
popd || exit
