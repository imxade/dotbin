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

    # Flatpak service
    flatpak = {
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };

      packages = [
        "com.brave.Browser"
        "com.github.tchx84.Flatseal"
        "org.gnome.Boxes"
        "com.vscodium.codium"
        /*
        "org.wezfurlong.wezterm"

        "com.github.d4nj1.tlpui"
        "org.blender.Blender"
        "io.mpv.Mpv"
        "org.ryujinx.Ryujinx"
        "com.github.xournalpp.xournalpp"
        "net.lutris.Lutris"
        "org.cubocore.CoreKeyboard"
        "com.obsproject.Studio "

        "io.neovim.nvim"
        "dev.lapce.lapce"
        "dev.zed.Zed-Preview"

        "com.helix_editor.Helix"
        "org.freedesktop.Sdk.Extension.typescript"
        "org.freedesktop.Sdk.Extension.rust-stable"
        "org.freedesktop.Sdk.Extension.llvm20"
        "org.freedesktop.Sdk.Extension.node24"
        */
      ];
    };
  };

/*
  xdg = {
    portal = {
      extraPortals = with pkgs; [
        # xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
      # wlr.enable = true;
    };
  };
*/

}
