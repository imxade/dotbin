#!/bin/sh

flakeDir="${HOME}/.config/osnix"
if command -v nh >/dev/null 2>&1; then
  nh os switch --update --hostname "nixos" "${flakeDir}"
else
  nix flake update --show-trace --flake "${flakeDir}"
  # nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace
fi
