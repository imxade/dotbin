{ lib, pkgs, config, ... }:

{
  environment = {
    # List packages installed in xorg profile.
    systemPackages = with pkgs; [
      exiftool # Manipulate Metadata
      wezterm
      gammastep # Manage Screen Color Temperature
      /*
      zed-editor-fhs
      alacritty
      lapce
      seatd  # elogind Replacement
      brave		# Browser
      swtpm		# Virtual TPM
      */
    ];

    # shellAliases = { hx="flatpak run --env=PATH=/app/bin:/usr/bin:~/.local/bin com.helix_editor.Helix"; };
  };

  /*
  sound = { # ALSA sound enable
    enable = false;
    mediaKeys = { # Keyboard Media Keys
      enable = true;
    };
  };
  */

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
      enable = true;
      uninstallUnmanaged = true;
      update.auto = {
        enable = true;
        onCalendar = "weekly"; # Default value
      };

      packages = [
        "com.brave.Browser"
        "com.github.tchx84.Flatseal"
        "org.gnome.Boxes"
        "dev.zed.Zed-Preview"
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

        "com.helix_editor.Helix"
        "io.neovim.nvim"
        "dev.lapce.lapce"
        "com.vscodium.codium"

        "org.freedesktop.Sdk.Extension.typescript"
        "org.freedesktop.Sdk.Extension.rust-stable"
        "org.freedesktop.Sdk.Extension.llvm20"
        "org.freedesktop.Sdk.Extension.node24"
        */
      ];
    };
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        # xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
