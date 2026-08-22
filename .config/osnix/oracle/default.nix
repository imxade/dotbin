{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
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
  # This limits /boot growth while retaining rollback capability.
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
  # x86_64 USERSPACE EMULATION
  # ==========================================================

  boot.binfmt.emulatedSystems = [
    # "x86_64-linux"
  ];

  # ==========================================================
  # NIX
  # ==========================================================

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Deduplicate identical files as they are added.
    # This saves space at the cost of some extra work during
    # store additions.
    auto-optimise-store = true;
  };

  # Periodically perform a full store optimisation.
  #
  # This scans the store and hard-links identical files.
  nix.optimise = {
    automatic = true;

    dates = [
      "03:45"
    ];
  };

  # Automatically remove old/unreferenced Nix store paths.
  #
  # 14 days is conservative enough to retain rollback history
  # while keeping the 47 GB VM from accumulating indefinitely.
  nix.gc = {
    automatic = true;

    dates = "weekly";

    options = "--delete-older-than 14d";
  };

  # ==========================================================
  # BASIC UTILITIES
  # ==========================================================

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    htop
    evil-helix
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
  # TIME
  # ==========================================================

  time.timeZone = "Asia/Kolkata";

  # ==========================================================
  # LOCALE
  # ==========================================================

  i18n.defaultLocale = "en_US.UTF-8";

  # ==========================================================
  # STATE VERSION
  # ==========================================================

  system.stateVersion = "26.05";
}
