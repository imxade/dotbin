{ lib, pkgs, config, ... }:

{

  # SwapFile
  swapDevices = [{
    device = "/.swap";
    size = 8 * 1024;
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

  networking = {
    interfaces = {
      #	   	wlp6s0 	  = {
      #	   	useDHCP = true;
      #	   	};
    };
  };

  services = {
    logind = {
      lidSwitch = "ignore"; # Do not Suspend when Lid is Closed
    };
    tlp = {
      enable = true; # enable tlp recommended for laptops
      settings = { };
    };
    pipewire = { # Pipewire for Audio
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = { enable = true; };
    };
    fwupd = { enable = true; };
    thermald = { enable = true; };
  };

  hardware = {
    # enableAllFirmware = true;
    # Enable Bluetooth
    bluetooth = {
      enable = true;
      settings = {
        Policy = {
          # Auto Enable Bluetooth
          AutoEnable = "true";
        };
        General = {
          Enable = "Source,Sink,Media,Socket";
          ControllerMode = "bredr";
          # Bluetooth device always visible
          #			    DiscoverableTimeout = "0";
        # };
      };
    };
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
}
