#!/bin/sh

pushd "${HOME}/.config/osnix" &&
# nix-store --gc &&
sudo umount -Rl /nix/store
sudo chown -R ${USER} /nix
nix-store --delete &&
nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace &&
popd || exit

