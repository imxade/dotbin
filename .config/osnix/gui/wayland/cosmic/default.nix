{ lib, pkgs, config, ... }:

{
  # Include Universal wayland Config
  imports = [ ../default.nix ];

  # Enable Cosmic Desktop
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };

  environment = {
    cosmic.excludePackages = with pkgs; [
      cosmic-term
      cosmic-edit
    ];
    /*
    systemPackages = with pkgs; [
      cosmic-ext-tweaks
    ];
    */
  };
}

