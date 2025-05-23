{ lib, pkgs, config, ... }:

{
  # Include Universal xorg Config
  imports = [ ../default.nix ];

  # Enable Cosmic Desktop
  services = {
    desktopManager.cosmic.enable = true;
  };
}
