#!/bin/sh

flakeDir="${HOME}/.config/osnix"
if command -v nh >/dev/null 2>&1; then
  nh os switch --hostname "nixos" "${flakeDir}"
else
  sudo nixos-rebuild switch --impure --flake  "${flakeDir}#nixos" --show-trace # --option sandbox false
fi
