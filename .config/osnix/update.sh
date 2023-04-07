#!/bin/sh

pushd "${HOME}/.config/osnix" &&
# nix-store --gc &&
nix-store --delete &&
nix --experimental-features "nix-command flakes" flake update --commit-lock-file --show-trace &&
popd || exit

