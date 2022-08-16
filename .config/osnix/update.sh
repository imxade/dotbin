#!/bin/sh

pushd "${HOME}/.config/osnix" &&
nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace &&
su root -c "
cp /etc/nixos/hardware-configuration.nix . &&
nixos-rebuild switch --impure --flake .# --show-trace 
" &&
popd || exit

