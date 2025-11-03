{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # Base ISO installer
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  # Use the latest Linux kernel
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  /*
  # Optional: Enable a basic user account (handy for testing)
  users.users.nixos = {
    isNormalUser = true;
    password = "nixos";
    extraGroups = [ "wheel" ];
  };

  # Optional: Enable sudo without password for convenience
  security.sudo.wheelNeedsPassword = false;
  */

  # Optional: ISO label
  image.fileName = "inspiron3442-nixos-live.iso";
  services.getty.autologinUser = lib.mkForce "x";

  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.timeout = lib.mkForce 10;
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" ];
  services.btrfs.autoScrub.enable = lib.mkForce false;

  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-57-6.12.56"
  ];

  environment.etc."skel".source = ./home;

  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  # --- Firmware (for both vendors) ---
  hardware.enableRedistributableFirmware = true;
  hardware.firmware = with pkgs; [
    linux-firmware
    # amd-ucode
    # intel-ucode
  ];
}
