{ lib, pkgs, config, ... }:

{
  # Include Universal xorg Config
  imports = [ ../default.nix ];

  # Configure the X11 windowing system.
  services = {
    xserver = {
      # Configure WindowManager
      windowManager = { qtile = { enable = true; }; };
    };
  };
}
