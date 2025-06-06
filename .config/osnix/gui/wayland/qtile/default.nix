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
    logind = {
      lidSwitch = "ignore"; # Do not Suspend when Lid is Closed
    };
    tlp = {
      enable = true; # enable tlp recommended for laptops
      settings = { };
    };
    pipewire = { # Pipewire for Audio
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = { enable = true; };
    };
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
