{ lib, pkgs, config, ... }:

{
  # Include Universal xorg Config
  imports = [ ../default.nix ];

  environment = {
    # List packages installed in xorg profile.
    systemPackages = with pkgs; [
      slurp # wayland region selector
      grim # wayland screenshot
      wf-recorder # wayland screen recorder
      wl-clipboard # wayland clipboard
    ];
  };


  # Configure the X11 windowing system.
  services = {
    xserver = {
      # Configure WindowManager
      windowManager = { qtile = { enable = true; }; };
    };
    # Configure DisplayManager
    displayManager = {
      defaultSession = "none+qtile";
      # lightdm = { enable = false; };
    };
  };
}
