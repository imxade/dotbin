{ lib, pkgs, config, ... }:

{
  environment = {
    # Define Environment xorg wide variables
    variables = { TERMINAL = "alacritty"; };

    # List packages installed in xorg profile.
    systemPackages = with pkgs; [
      #		seatd		# elogind Replacement
      exiftool # Manipulate Metadata
      alacritty # Terminal Emulator
      gammastep # Manage Screen Color Temperature
      #		brave		# Browser
      #		swtpm		# Virtual TPM
    ];
  };

# sound = { # ALSA sound enable
#   enable = false;
#   mediaKeys = { # Keyboard Media Keys
#     enable = true;
#   };
# };

  # Configure the X11 windowing system.
  services = {
    xserver = {
      enable = false;

      # Configure DesktopManager
      desktopManager = {
        xterm = {
          enable = false; # Do not install xterm
        };
      };
    };
  };

  xdg = {
    portal = {
      extraPortals = with pkgs; [
        # xdg-desktop-portal-cosmic
        # xdg-desktop-portal-gtk
      ];
      # config.common.default = "*";
      # wlr.enable = true;
    };
  };
}
