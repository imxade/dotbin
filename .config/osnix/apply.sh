#!/bin/sh

sudo nixos-rebuild switch --impure --show-trace  --flake "${HOME}/.config/osnix#nixos" --option sandbox false
