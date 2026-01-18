{ inputs, lib, pkgs, config, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
    # ./cursor-script-compat.nix
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
      appimage-run

      /*
      # AI IDE
      antigravity-fhs
      google-chrome

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
    logind.settings = {
      Login = {
        HandlePowerKey = "hibernate";
        HandleLidSwitch = "hibernate";
        HandleLidSwitchDocked = "hibernate";
      };
    };

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
        "io.github.benjamimgois.goverlay"
        "com.github.xournalpp.xournalpp"
        "org.godotengine.Godot"
        "io.github.ryubing.Ryujinx"
        "org.videolan.VLC"
        "com.obsproject.Studio"
        "it.mijorus.gearlever"
        "md.obsidian.Obsidian"
        "com.heroicgameslauncher.hgl"
        "ink.whis.Whis"
        /*
        "com.google.Chrome"
        "net.lutris.Lutris"
        "com.valvesoftware.Steam"
        "com.heroicgameslauncher.hgl"
        "org.cubocore.CoreKeyboard"
        "org.libretro.RetroArch"
        "com.github.d4nj1.tlpui"
        "org.wezfurlong.wezterm"

        "org.blender.Blender"
        "io.mpv.Mpv"

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
      /*
      extraPortals = with pkgs; [
        # xdg-desktop-portal-cosmic
        xdg-desktop-portal-gtk
      ];
      config.common.default = "gtk";
      */
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
    virtualbox.host = {
      # Enable VirtualBox host
      enable = true;

      # Needed for USB (webcam, mic, etc.)
      enableExtensionPack = true;
    };
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

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc

    # GTK / GLib stack
    glib
    atk
    pango
    cairo
    gdk-pixbuf
    gtk3

    # DBus / system
    dbus
    expat

    # X11 stack  ← THIS FIXES libX11.so.6
    xorg.libX11
    xorg.libXcursor
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXtst
    xorg.libXi
    xorg.libXfixes
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXinerama
    xorg.libxcb
    xorg.libXext

    # Graphics
    libdrm
    libgbm
    mesa

    # Audio
    alsa-lib
    pulseaudio
    pipewire

    # Wayland (harmless even on X11)
    wayland
    libxkbcommon

    # Electron / Chromium
    nss
    nspr
    cups
  ];

}
