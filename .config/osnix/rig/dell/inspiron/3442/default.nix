{ inputs, lib, pkgs, config, ... }:

{
  imports = [
    # "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/inspiron/3442"
    inputs.nixos-hardware.nixosModules.dell-inspiron-3442
  ];

  # SwapFile
  swapDevices = [{
    device = "/.swap";
    size = 5 * 1024;
  }];

  environment = {
    # List packages installed for inspiron_3442
    systemPackages = with pkgs; [
      btrfs-progs # Manage BTRFS
      # bluez-alsa			# Pure Alsa Bluetooth
      shellcheck
      cryptsetup
      lvm2
      exfat
      ntfs3g
    ];
  };

  /*
  networking = {
    interfaces = {
      wlp6s0 	  = {
      useDHCP = true;
      };
    };
  };

  services = {
    fwupd = { enable = true; };
    thermald = { enable = true; };
  };

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver # LIBVA_DRIVER_NAME=iHD
      ];
    };
  };

  boot = {
    #	    # Better set the following inside ~/.asoundrc
    #	    extraModprobeConfig = ''
    #             # set hda-intel as default card
    #    	      options snd slots=snd-hda-intel
    #             # disable 1st card, enable 2nd card
    #   	      options snd_hda_intel enable=0,1
    #    	    '';
    kernelModules = [ "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    kernelParams = [
      # "acpi_osi=!acpi_osi=\"Windows 2009\""
    ];
  };
  */
}

