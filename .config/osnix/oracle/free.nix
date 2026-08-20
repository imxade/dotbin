{ config, lib, pkgs, modulesPath, ... }:

{
  # ==========================================================
  # VIRTUAL MACHINE HARDWARE
  #
  # OCI Ampere A1 uses a virtualized/virtio device model.
  # qemu-guest.nix provides the required initrd drivers for
  # virtio storage and networking.
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
  #
  # Keep OCI networking on DHCP.
  #
  # net.ifnames=0 gives the interface the predictable name
  # eth0, matching the OCI/NixOS cloud setup.
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


  # ==========================================================
  # DISK
  #
  # Oracle A1 boot volume:
  #
  #   /dev/sda
  #
  # Layout:
  #
  #   /dev/sda1   512 MiB EFI
  #   /dev/sda2   remainder Btrfs
  #
  # Btrfs subvolumes:
  #
  #   /root -> /
  #   /home -> /home
  #   /nix  -> /nix
  #
  # Disko generates the corresponding mount configuration.
  #
  # WARNING:
  # This disk is completely erased during installation.
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
  #
  # The public key is installed separately by
  # nixos-anywhere --extra-files.
  #
  # No SSH key is stored in this configuration.
  # ==========================================================

  services.openssh.enable = true;

  services.openssh.settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "prohibit-password";
  };


  # ==========================================================
  # x86_64 USERSPACE EMULATION
  #
  # The machine itself remains:
  #
  #   aarch64-linux
  #
  # Only x86_64 Linux executables use QEMU/binfmt.
  # ==========================================================

  boot.binfmt.emulatedSystems = [
    # "x86_64-linux"
  ];


  # ==========================================================
  # NIX
  # ==========================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # cache.nixos.org is the default substituter.

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
    btop
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