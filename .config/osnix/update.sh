#!/bin/sh

pushd "${HOME}/.config/osnix" &&
# nix-store --gc &&
# sudo umount -Rl /nix/store
# sudo chown -R ${USER} /nix
# nix-store --delete &&
sudo nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace &&
# sudo chown -R root /nix &&
popd || exit

