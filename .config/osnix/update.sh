#!/bin/sh

pushd "${HOME}/.config/osnix" || exit 1

if command -v nh >/dev/null 2>&1; then
  nh os switch --update --hostname "nixos" "${HOME}/.config/osnix"
else
  sudo nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace
fi

popd || exit 1
