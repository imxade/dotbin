 { lib
 , pkgs
 , config
 , ...
 }:

 {
   environment = {
           # List packages installed for inspiron_3442
           systemPackages = with pkgs; [
 		btrfs-progs 				# Manage BTRFS
           ];
   };

   services = {
	   logind = {
		   lidSwitch = "ignore"; # Do not Suspend when Lid is Closed
	   };
   };

   hardware = {
	    enableAllFirmware = true;
	    # Enable Bluetooth
	    bluetooth = {
		enable   = true;
		hsphfpd  = {
		        enable  = true;
		};
		settings = {
		        General = {
		    	    Enable ="Source,Sink,Media,Socket";
		        };
		};
	    };
	    opengl = {
		enable = true;
		extraPackages = with pkgs; [
		  intel-media-driver 			# LIBVA_DRIVER_NAME=iHD
#		  vaapiIntel         			# LIBVA_DRIVER_NAME=i965 (older, works better with browsers)
		  vaapiVdpau
		  libvdpau-va-gl
		];
	    };
    };

#   networking = {
#           enableB43Firmware = true;
#   };
    
    boot = {
 	    extraModprobeConfig = ''
	      # set hda-intel as default card
     	      options snd slots=snd-hda-intel
	      # disable 1st card, enable 2nd card
    	      options snd_hda_intel enable=0,1
     	    '';
 	    blacklistedKernelModules = [
 	      "b43" 
 	      "bcma" 
 	    ];
 	    extraModulePackages = [
 	      config.boot.kernelPackages.broadcom_sta
 	    ];
#	    kernelPackages = mkDefault pkgs.linuxPackages_hardened;
#	    kernelModules = [
#	      "kvm-intel"
#	      "nvme"
#	    ];
#	    initrd ={
#	      availableKernelModules = [ 
#		"ahci" 
#		"usbhid"
#	        "xhci_hcd"
#		"usb_storage" 
#	      ];
#	    kernelModules = [
#	      "nvme"
#	    ];
    };
 }
