#!/bin/sh
pushd "${HOME}/.config/osnix" || exit
nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace
su root -c "nixos-rebuild switch --flake .# --show-trace" # --arg USER ${USER} other variables"
popd || exit
