{ inputs, lib, pkgs, config, system, nixpkgs, ... }:
# Read 'Keys' with their 'Values' from value.toml
let
  # Modify value.toml, instead of Modifying Variables here
  Toml = builtins.fromTOML (builtins.readFile ./value.toml);
  RIG = Toml.RIG; # Profile of machine to be used
  GUI = Toml.GUI; # Profile for Graphical Environment
  USER = Toml.USER; # Username
  ZONE = Toml.ZONE; # Set your time zone
  HOST = Toml.HOST; # Hostname of current system
  DISK = Toml.DISK; # Disk for Boot Loader
  RUID = Toml.RUID; # UUID of Root device, For Hibernate
  FUID = Toml.FUID; # UUID of Fat partition holding grub.cfg
  OFFSET = Toml.OFFSET; # Offset value of swapfile, For Hibernate
  TOR_BRIDGE = Toml.TOR_BRIDGE; # Bridge line for tor daemon
  /*
  system = Toml.system; # Platform Architecture
  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };
  */
  # Use Above Variables in ...
in
{
  imports = [
     # Declarative Home Manager
     # inputs.home-manager.nixosModules.home-manager
     # FS Grofile
     # ./hardware-configuration.nix
     /etc/nixos/hardware-configuration.nix
     # Include Machine Profile
     ./${RIG}
     # Include GUI Profile
     ./${GUI}
     # Include Hardened Profile [Disables hibernation]
     ./rig/hard
     # Include Development Profile
     # ./dev
  ];

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" "space_cache=v2" ];
    "/home".options = [ "subvol=home" ];
  };
  # Select internationalisation properties.
  i18n = { defaultLocale = "en_US.UTF-8"; };
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  # System Fonts
  fonts.packages = [
    # pkgs.nerd-fonts.hurmit
    # pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.caskaydia-cove
  ];
  programs = {
    zsh.enable = true;
    nix-ld = {
      enable = true;
      libraries = with pkgs;
        [
          # Add any missing dynamic libs for
          # unpackaged program here
        ];
    };
    # nh = {
    #   enable = true;
    #   clean.enable = true;
    #   clean.extraArgs = "--keep 10";
    #   flake = "/home/${USER}/.config/osnix";
    # };

  };
  security = {
    unprivilegedUsernsClone = true; # For flatpak
    apparmor.enable = lib.mkForce false;
    rtkit.enable = true;
    # sudo.enable = false; # Disable sudo
  };
  # Configure SystemWide services
  services = {
    # BTRFS Scrub
    btrfs.autoScrub.enable = true;
    # Enable CUPS to print documents.
    # printing.enable = true;
    # Enable the OpenSSH daemon.
    openssh = {
      enable = false;
      allowSFTP = true;
      extraConfig = "  HostKeyAlgorithms +ssh-rsa\n";
    };
  };
  environment = {
    # Define Environment System Wide variables
    variables = {
      # fixes libstdc++ issues and libgl.so issues
      LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/";
      # fixes xcb issues :
      QT_PLUGIN_PATH="${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}";
    };
    # List packages installed in system profile.
    defaultPackages = [ ]; # Do not install anything by default
    systemPackages = with pkgs; [
      git # To take Care of Git repositories
      gawk # Text processing Language
      evil-helix # Text Editor
      libarchive # bsdtar : Utility to work with archives
      zoxide
      bottom
    ];
    /*
    # Create file /etc/current-system-packages with List of all Packages
    etc = {
      "current-system-packages" = {
        text = let
          packages = builtins.map (p: "${p.name}")
            config.environment.systemPackages;
          sortedUnique =
            builtins.sort builtins.lessThan (lib.unique packages);
          formatted = builtins.concatStringsSep "\n" sortedUnique;
        in formatted;
      };
    };
    */
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    # Enable Automatic Optimisation.
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
    # Enable Automatic Garbage Collection.
    gc = {
      automatic = true;
      dates = "weekly";
      # options = "--delete-older-than +10";
      options = "--delete-older-than 10d";
    };
  };

  # Following options uses variables declared in value.toml
  networking = {
    # hostName = "${HOST}"; # Define your hostname
    nameservers = [ "9.9.9.9" ];
    networkmanager.enable = true;
  };
  boot = {
    # Hibernate Options
    # kernelParams = [ "resume_offset=${OFFSET}" ];
    resumeDevice = "/dev/disk/by-uuid/${RUID}";
    initrd.systemd.enable = true;
    # Configure boot loader
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        enableCryptodisk = true;
        efiInstallAsRemovable = true;
        device = "${DISK}";
        extraEntries = ''
          menuentry "OTHER" {
          search --set=root --fs-uuid ${FUID}
          configfile /grub/grub.cfg }'';
      };
      efi = {
        # Mount Point for Fat Partition
        efiSysMountPoint = "/fat";
      };
      timeout = 2; # wait this much before auto-boot
    };
  };
  time.timeZone = "${ZONE}"; # Set your time zone.
  #
  # Define a user account.
  users = {
    users = {
      ${USER} = {
        # initialPassword	= "password";	# Password for the user
        isNormalUser = true;
        extraGroups = [
          "nixbld"
          "audio"
          "camera"
          "docker"
          "fuse"
          "input"
          "libvirt"
          "networkmanager"
          "podman"
          "scanner"
          "seat"
          "seatd"
          "video"
          "wheel"
        ];
        shell = pkgs.zsh; # Default shell
      };
    };
  };
  # Configure SystemWide services
  services = {
    # Auto Login
    getty.autologinUser = "${USER}";
    displayManager.autoLogin = {
      enable = true;
      user = "${USER}";
    };
    # Enable Tor proxy
    tor = {
      enable = true;
      client = {
        enable = true;
        socksListenAddress = {
          IsolateDestAddr = true;
          addr = "127.0.0.1"; # Socks Host
          port = 9050; # Port
        };
      };
      settings = {
        /*
        SOCKSPort = [
          {
            port = 9090;
          }
        ];
        Bridge = "obfs4 IP:ORPort [fingerprint]";
        */
        UseBridges = true;
        Bridge = "${TOR_BRIDGE}";
        ClientTransportPlugin =
          "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
      };
    };
  };
  system = {
    # Enable Automatic Upgrades.
    autoUpgrade = {
      enable = true;
      allowReboot = false;
      flake = inputs.self.outPath;
      # channel = "https://nixos.org/channels/nixos-unstable";
      flags = [
        "--update-input"
        "nixpkgs"
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
    stateVersion = "21.11"; # Do not modify
  };
  /*
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users = {
      ${USER} = { lib, pkgs, config, system, nixpkgs, ... }: {
        imports = [({
          home = {
            username = "${USER}";
            homeDirectory = "/home/${USER}";
            stateVersion = "21.11"; # Do not modify
          };
        })] ++ [ (import ./${GUI}/home.nix) ];
      };
    };
  };
  */
}
