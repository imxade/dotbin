#!/bin/sh

pushd "${HOME}/.config/osnix" || exit 1

if command -v nh >/dev/null 2>&1; then
  nh os switch --hostname "nixos" "${HOME}/.config/osnix"
else
  sudo nixos-rebuild switch --impure --flake .#nixos --show-trace --option sandbox false
fi
"

popd || exit 1
