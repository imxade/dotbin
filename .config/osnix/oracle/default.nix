{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  documentation.enable = false;
  documentation.doc.enable = false;
  documentation.man.enable = false;
  documentation.info.enable = false;

  # ==========================================================
  # VIRTUAL MACHINE HARDWARE
  # ==========================================================

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  # ==========================================================
  # HOST
  # ==========================================================

  networking.hostName = "oracle-a1";

  # ==========================================================
  # NETWORK
  # ==========================================================

  networking.useDHCP = true;

  boot.kernelParams = [
    "net.ifnames=0"
  ];

  # ==========================================================
  # BOOT
  # ==========================================================

  boot.loader.systemd-boot.enable = true;

  boot.loader.efi.canTouchEfiVariables = true;

  # Keep only a small number of bootable generations.
  boot.loader.systemd-boot.configurationLimit = 3;

  # ==========================================================
  # DISK
  # ==========================================================

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";

    content = {
      type = "gpt";

      partitions = {
        EFI = {
          size = "512M";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";

            mountOptions = [
              "umask=0077"
            ];
          };
        };

        root = {
          size = "100%";

          content = {
            type = "btrfs";

            extraArgs = [
              "-f"
            ];

            subvolumes = {
              "/root" = {
                mountpoint = "/";

                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/home" = {
                mountpoint = "/home";

                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "/nix" = {
                mountpoint = "/nix";

                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };

  # ==========================================================
  # ZRAM
  # ==========================================================

  zramSwap.enable = true;

  # ==========================================================
  # SSH
  # ==========================================================

  services.openssh.enable = true;

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "prohibit-password";
  };

  # ==========================================================
  # NIX
  # ==========================================================

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    auto-optimise-store = true;
  };

  nix.optimise = {
    automatic = true;

    dates = [
      "03:45"
    ];
  };

  nix.gc = {
    automatic = true;

    dates = "weekly";

    options = "--delete-older-than 14d";
  };

  # ==========================================================
  # BASIC UTILITIES & RUNTIMES
  # ==========================================================

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    evil-helix
    google-chrome
    sqlite
  ];

  # ==========================================================
  # FIREWALL
  # ==========================================================

  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      22
    ];
  };

  # ==========================================================
  # TIME & LOCALE
  # ==========================================================

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";

  # ==========================================================
  # BROWSER PROFILE / SESSION SYNC
  # ==========================================================

  systemd.tmpfiles.rules = [
    "d /var/lib/browser-session 0777 root root -"
  ];

  # ==========================================================
  # STATE VERSION
  # ==========================================================

  system.stateVersion = "26.05";
}
