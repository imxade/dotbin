{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Base ISO installer
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Use the latest Linux kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # Optional: Enable a basic user account (handy for testing)
  #  users.users.x.home = "/etc/skel";

  # Optional: Enable sudo without password for convenience
  security.sudo.wheelNeedsPassword = false;

  # Optional: ISO label
  image.fileName = "inspiron3442-nixos-live.iso";
  services.getty.autologinUser = lib.mkForce "x";

  boot.resumeDevice = lib.mkForce "";
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.timeout = lib.mkForce 10;
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" ];
  services.btrfs.autoScrub.enable = lib.mkForce false;
  environment.etc."skel".source = ./home;

  systemd.tmpfiles.rules = [
    "d /home/x 0755 x x"
  ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  # --- Firmware (for both vendors) ---
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
  ];

  environment = {
    # List packages installed in xorg profile.
    systemPackages = with pkgs; [
      gparted
      brave		# Browser
      hw-probe
      perlPackages.Clone
    ];
  };

}
