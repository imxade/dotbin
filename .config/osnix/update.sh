#!/bin/sh

# nix-store --gc &&
# sudo umount -Rl /nix/store
# sudo chown -R ${USER} /nix
# nix-store --delete &&
# nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace "${HOME}/.config/osnix"
nix flake update --show-trace --flake "${HOME}/.config/osnix"
