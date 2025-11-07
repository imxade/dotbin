{ inputs, lib, pkgs, config, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  environment = {
    # List packages installed in xorg profile.
    systemPackages = with pkgs; [
      exiftool # Manipulate Metadata
      gammastep # Manage Screen Color Temperature
      wezterm
      gparted
      aria2
      python3
      /*
      podman-compose
      zed-editor
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
    spice-vdagentd.enable = true;
    lact.enable = true;

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
        "net.lutris.Lutris"
        "com.github.xournalpp.xournalpp"
        /*
        "com.github.d4nj1.tlpui"
        "org.wezfurlong.wezterm"

        "org.blender.Blender"
        "io.mpv.Mpv"
        "org.ryujinx.Ryujinx"
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

  # Persist login sessions on Brave
  security.pam.services.login.enableGnomeKeyring = true;

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

  hardware = {
    # Enable Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
        /*
      settings = {
        Policy = {
          # Auto Enable Bluetooth
          AutoEnable = "true";
        };
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "bredr";
          # Bluetooth device always visible
          # DiscoverableTimeout = "0";
        };
      };
        */
    };
  };

  virtualisation = {
    containers.enable = true;
    /*
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      # dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm = { enable = false; };
      };
    };
    */
    waydroid.enable = true;
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
